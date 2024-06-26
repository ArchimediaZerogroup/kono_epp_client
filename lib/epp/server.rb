module KonoEppClient #:nodoc:
  class Server
    include REXML
    include RequiresParameters

    require 'nokogiri'

    attr_accessor :tag, :password, :server, :port, :ssl_version, :old_server,
                  :services, :lang, :extensions, :version, :credit, :timeout,
                  :transport, :transport_options

    # ==== Required Attrbiutes
    #
    # * <tt>:server</tt> - The EPP server to connect to
    # * <tt>:tag</tt> - The tag or username used with <tt><login></tt> requests.
    # * <tt>:password</tt> - The password used with <tt><login></tt> requests.
    #
    # ==== Optional Attributes
    #
    # * <tt>:port</tt> - The EPP standard port is 700. However, you can choose a different port to use.
    # * <tt>:clTRID</tt> - The client transaction identifier is an element that EPP specifies MAY be used to uniquely identify the command to the server. You are responsible for maintaining your own transaction identifier space to ensure uniqueness. Defaults to "ABC-12345"
    # * <tt>:old_server</tt> - Set to true to read and write frames in a way that is compatible with older EPP servers. Default is false.
    # * <tt>:lang</tt> - Set custom language attribute. Default is 'en'.
    # * <tt>:services</tt> - Use custom EPP services in the <login> frame. The defaults use the EPP standard domain, contact and host 1.0 services.
    # * <tt>:extensions</tt> - URLs to custom extensions to standard EPP. Use these to extend the standard EPP (e.g., Nominet uses extensions). Defaults to none.
    # * <tt>:version</tt> - Set the EPP version. Defaults to "1.0".
    # * <tt>:transport</tt> - Type of connection (http or tcp). Default to "tcp"
    # * <tt>:transport_options</tt> - Overrides for transport configurations. Default to {}
    # * <tt>:timeout</tt> - Timeou for connections in seconds. Default to "30"
    # * <tt>:ssl_version</tt> - Version of the ssl protocol versione. Default to TLSv1
    # * <tt>:ssl_version</tt> - Version of the ssl protocol versione. Default to TLSv1
    #
    def initialize(attributes = {})
      requires!(attributes, :tag, :password, :server)

      @tag = attributes[:tag]
      @password = attributes[:password]
      @server = attributes[:server]
      @port = attributes[:port] || 700
      @old_server = attributes[:old_server] || false
      @lang = attributes[:lang] || "en"
      @services = attributes[:services] || ["urn:ietf:params:xml:ns:domain-1.0", "urn:ietf:params:xml:ns:contact-1.0", "urn:ietf:params:xml:ns:host-1.0"]
      @extensions = attributes[:extensions] || []
      @version = attributes[:version] || "1.0"
      @transport = attributes[:transport] || :tcp
      @transport_options = attributes[:transport_options] || {}
      @timeout = attributes[:timeout] || 30
      @ssl_version = attributes[:ssl_version] || :TLSv1

      @logged_in = false
    end

    def connect_and_hello
      open_connection

      hello
    end

    # Closes the connection to the EPP server.
    def close_connection
      @connection.close
    end

    # Sends an XML request to the EPP server, and receives an XML response.
    # <tt><login></tt> and <tt><logout></tt> requests are also wrapped
    # around the request, so we can close the socket immediately after
    # the request is made.
    def request(xml)
      # open_connection

      # @logged_in = true if login

      begin
        @response = send_request(xml)
      ensure
        if @logged_in && !old_server
          @logged_in = false if logout
        end
      end

      return @response
    end

    # Sends a standard login request to the EPP server.
    def login
      login = KonoEppLogin.new(tag, password)

      # FIXME: Order matters
      login.version = version
      login.lang = lang

      login.services = services
      login.extensions = extensions

      send_command(login)
    end

    def change_password(new_password)
      login = KonoEppLogin.new(tag, password)

      # FIXME: Order matters
      login.new_password = new_password

      login.version = version
      login.lang = lang

      login.services = services
      login.extensions = extensions

      send_command(login)
    end

    def logged_in?
      begin
        poll
      rescue
        return false
      end

      return true
    end

    # FIXME: Remove command wrappers?
    def hello
      send_request(KonoEppHello.new.to_s)
    end

    def poll(id = nil)
      poll = KonoEppPoll.new(id ? :ack : :req)

      poll.ack_id = id if id

      send_command(poll)
    end

    def create_contact(options)
      contact = KonoEppCreateContact.new options
      send_command(contact)
    end

    def check_contacts(ids)
      send_command(KonoEppCheckContacts.new(ids))
    end

    def delete_contact(id)
      contact = KonoEppDeleteContact.new id
      send_command(contact)
    end

    def update_contact(options)
      contact = KonoEppUpdateContact.new options
      send_command(contact)
    end

    def create_domain(options)
      domain = KonoEppCreateDomain.new options
      send_command(domain)
    end

    def check_domains(*domains)
      send_command(KonoEppCheckDomains.new *domains)
    end

    def update_domain(options)
      domain = KonoEppUpdateDomain.new options
      send_command(domain)
    end

    def delete_domain(name)
      domain = KonoEppDeleteDomain.new name
      send_command(domain)
    end

    def info_contact(id)
      contact = KonoEppInfoContact.new id
      send_command(contact)
    end

    def info_domain(name)
      info = KonoEppInfoDomain.new name
      send_command(info)
    end

    def transfer_domain(name, authinfo, op, extension: nil)
      send_command(KonoEppTransferDomain.new(name, authinfo, op, extension: extension))
    end

    # Sends a standard logout request to the EPP server.
    def logout
      send_command(KonoEppLogout.new, 1500)
    end

    # private
    # Wrapper which sends XML to the server, and receives
    # the response in return.
    def send_request(xml)
      write(xml)
      read
    end

    def send_command(command, expected_result = 1000..1999)
      namespaces = {'extepp' => 'http://www.nic.it/ITNIC-EPP/extepp-2.0',
                    'xmlns' => "urn:ietf:params:xml:ns:epp-1.0"}

      xml = Nokogiri.XML(send_request(command.to_s))

      # TODO: multiple <response> RFC 3730 §2.6
      result = xml.at_xpath("/xmlns:epp/xmlns:response[1]/xmlns:result",
                            namespaces)
      raise KonoEppErrorResponse.new(:message => 'Malformed response') if result.nil?

      xmlns_code = result.at_xpath("@code")
      raise KonoEppErrorResponse.new(:message => 'Malformed response') if xmlns_code.nil?

      response_code = xmlns_code.value.to_i

      xmlns_msg = result.xpath("xmlns:msg/text ()",
                               namespaces)
      raise KonoEppErrorResponse.new(:message => 'Malformed response') if xmlns_msg.empty?

      result_message = xmlns_msg.text.strip

      # TODO: value

      xmlns_ext_reason = result.xpath("xmlns:extValue/xmlns:reason",
                                      namespaces)
      result_message += ": #{xmlns_ext_reason.text.strip}" unless xmlns_ext_reason.empty?

      xmlns_reason_code = result.xpath("xmlns:extValue/xmlns:value/extepp:reasonCode",
                                       namespaces)
      reason_code = xmlns_reason_code.text.strip.to_i unless xmlns_reason_code.empty?

      credit_msg = xml.xpath("//extepp:credit/text ()",
                             namespaces)
      @credit = credit_msg.text.to_f unless credit_msg.empty?

      if expected_result === response_code
        return xml
      end

      args = {:xml => xml,
              :response_code => response_code,
              :reason_code => reason_code,
              :message => result_message}

      case [response_code, reason_code]
      when [2200, 6004]
        raise KonoEppAuthenticationPasswordExpired.new(args)
      when [2002, 4015]
        raise KonoEppLoginNeeded.new(args)
      when [2304, 9022]
        raise KonoEppDomainHasStatusCliTransProhibited.new(args)
      when [2304, 9026]
        raise KonoEppDomainHasStatusClientUpdateProhibited.new(args)
      else
        raise KonoEppErrorResponse.new(args)
      end
    end

    # Establishes the connection to the server. If the connection is
    # established, then this method will call read and return
    # the EPP <tt><greeting></tt> which is sent by the
    # server upon connection.
    def open_connection
      # FIXME il timeout serve solamente nella versione tcp
      # FIXME perchè utilizzare un'istanza di classe? non sarebbe meglio avere un metodo che genera il transport
      #       e successivamente viene utilizzato sempre quello?
      Timeout.timeout @timeout do
        case @transport
        when :tcp
          @connection = KonoEppClient::Transport::TcpTransport.new(server, port)
        when :http

          options = {
            ssl_version: ssl_version,
            cookie_file: "#{@tag.downcase}.cookies.pstore"
          }.merge(@transport_options)

          @connection = KonoEppClient::Transport::HttpTransport.new(server, port, **options)

        end
      end
    end

    # Receive an EPP response from the server. Since the connection is blocking,
    # this method will wait until the connection becomes available for use. If
    # the connection is broken, a SocketError will be raised. Otherwise,
    # it will return a string containing the XML from the server.
    def read
      Timeout.timeout @timeout do
        @connection.read
      end
    end

    # Send XML to the server. If the socket returns EOF,
    # the connection has closed and a SocketError is raised.
    def write(xml)
      Timeout.timeout @timeout do
        @connection.write(xml)
      end
    end
  end
end

require 'net/http'

module KonoEppClient::Transport
  class HttpTransport
    include KonoEppClient::Transport

    require 'pstore'

    # @param [String] server
    # @param [Integer] port
    # @param [Symbol] ssl_version -> Versione ssl
    # @param [String] cookie_file -> identifica il nome del file del cookie-store
    def initialize(server, port, ssl_version: :TLSv1, cookie_file: "cookies.pstore")
      @net_http = Net::HTTP.new( server, port )

      @net_http.use_ssl = true
      @net_http.ssl_version = ssl_version
      @net_http.verify_mode = OpenSSL::SSL::VERIFY_PEER

      #FIXME: Commented because not work on MacOS (dev machine), is necessary for Linux machine?
      #@net_http.ca_path = '/etc/ssl/certs' 

      # @net_http.set_debug_output $stderr
       #@net_http.set_debug_output File.open( "/tmp/net.log", "a")

      @store = PStore.new( cookie_file )
    end

    def read
      #puts @response.body
      @response.body
    end

    def write( xml )
      @store.transaction do
        cookie_str = '$Version="1"'
        @store[:cookies].each do |c|
          cookie_str += "; #{c[:name]}=#{c[:value]}"
        end if @store[:cookies]

        header = { "Cookie" => cookie_str }

        @response = @net_http.post( "/", xml, header )

        @store[:cookies] = parse_set_cookie( @response["Set-Cookie"] ) if @response["Set-Cookie"]
      end
    end

    def close
    end

  private
    def parse_set_cookie( string )
      cookies = []

      string.split( "," ).each do |cookie|
        tokens = cookie.split ";"

        name, value = tokens[0].split( "=", 2 )
        # TODO: complete parsing. Maybe encapsulate the cookie as well.
        cookies << { :name => name, :value => value }
      end

      return cookies
    end

    def http_post
    end
  end
end

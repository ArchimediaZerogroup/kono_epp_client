module KonoEppClient::Commands
  class Login < Command
    def initialize(id = nil, password = nil)
      super(nil, nil)

      @command = root.elements['command']
      @login = @command.add_element("login")

      @login.add_element("clID").text = id if id
      @login.add_element("pw").text = password if password

      @command.add_element("clTRID").text = "ABC-12345"
    end

    def version=(value)
      @options = @login.add_element("options") unless @options
      @options.add_element("version") unless @options.elements['version']

      @options.elements['version'].text = value
    end

    def version
      return nil unless @options
      version = @options.elements['version']

      version.text if version
    end

    def lang=(value)
      @options = @login.add_element("options") unless @options
      @options.add_element("lang") unless @options.elements['lang']

      @options.elements['lang'].text = value
    end

    def lang
      return nil unless @options
      lang = @options.elements['lang']

      lang.text if lang
    end

    def new_password=(value)
      newpw = @login.add_element("newPW")
      newpw.text = value
    end

    def services=(services)
      svcs = @login.add_element("svcs") unless @login.elements['svcs']
      services.each { |service| svcs.add_element("objURI").text = service }
    end

    def services
      svcs = @login.elements['svcs']

      res = []
      svcs.elements.each("objURI") { |obj| res << obj.text } if svcs

      return res
    end

    def extensions=(extensions)
      svcs = @login.elements['svcs']

      svcs = @login.add_element("svcs") unless svcs

      # Include schema extensions for registrars which require it
      extensions_container = svcs.add_element("svcExtension") unless extensions.empty?

      for uri in extensions
        extensions_container.add_element("extURI").text = uri
      end
    end

    def extensions
      svcs_extension = @login.elements['svcs/svcExtension']

      res = []
      svcs_extension.elements.each("extURI") { |obj| res << obj.text } if svcs_extension

      res
    end
  end
end

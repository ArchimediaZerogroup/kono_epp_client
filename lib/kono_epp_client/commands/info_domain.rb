module KonoEppClient::Commands
  class InfoDomain < Command
    def initialize(name)
      super(nil, nil)

      command = root.elements['command']
      info = command.add_element("info")

      domain_info = info.add_element("domain:info", {"xmlns:domain" => "urn:ietf:params:xml:ns:domain-1.0",
                                                     "xsi:schemaLocation" => "urn:ietf:params:xml:ns:domain-1.0 domain-1.0.xsd"})

      domain_name = domain_info.add_element "domain:name", {"hosts" => "all"}
      domain_name.text = name
    end
  end
end

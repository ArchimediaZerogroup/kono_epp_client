include REXML
module KonoEppClient::Commands
  class Command < REXML::Document
    def initialize(source = nil, context = nil)
      super(source, context)

      add(XMLDecl.new("1.0", "UTF-8", "no"))

      epp = add_element("epp", {"xmlns" => "urn:ietf:params:xml:ns:epp-1.0",
                                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                                "xsi:schemaLocation" => "urn:ietf:params:xml:ns:epp-1.0 epp-1.0.xsd"})

      epp.add_element("command")
    end
  end
end

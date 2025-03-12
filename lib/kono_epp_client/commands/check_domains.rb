# frozen_string_literal: true
module KonoEppClient::Commands

class CheckDomains < Command
  def initialize( *domains )
    super( nil, nil )

    command = root.elements['command']
    check = command.add_element( "check" )

    domain_check = check.add_element( "domain:check", { "xmlns:domain" => "urn:ietf:params:xml:ns:domain-1.0",
                                                     "xsi:schemaLocation" => "urn:ietf:params:xml:ns:domain-1.0 domain-1.0.xsd" } )

    domains.each do |d|
      domain_name = domain_check.add_element "domain:name"
      domain_name.text = d
    end
  end
end
end

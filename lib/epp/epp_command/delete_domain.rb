class KonoEppDeleteDomain < KonoEppCommand
  def initialize( name )
    super( nil, nil )

    command = root.elements['command']
    delete = command.add_element( "delete" )

    domain_delete = delete.add_element( "domain:delete", { "xmlns:domain" => "urn:ietf:params:xml:ns:domain-1.0",
                                                           "xsi:schemaLocation" => "urn:ietf:params:xml:ns:domain-1.0 domain-1.0.xsd" } )

    domain_name = domain_delete.add_element "domain:name"
    domain_name.text = name
  end
end

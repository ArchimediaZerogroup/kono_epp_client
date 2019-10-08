class KonoEppInfoContact < KonoEppCommand
  def initialize( id )
    super( nil, nil )

    command = root.elements['command']

    info = command.add_element "info"

    contact_info = info.add_element( "contact:info", { "xmlns:contact" => "urn:ietf:params:xml:ns:contact-1.0",
                                                       "xsi:schemaLocation" => "urn:ietf:params:xml:ns:contact-1.0 contact-1.0.xsd" } )

    contact_id = contact_info.add_element "contact:id"
    contact_id.text = id
 end
end

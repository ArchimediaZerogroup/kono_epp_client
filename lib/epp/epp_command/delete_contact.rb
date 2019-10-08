class KonoEppDeleteContact < KonoEppCommand
  def initialize( id )
    super( nil, nil )

    command = root.elements['command']

    delete = command.add_element "delete"

    contact_delete = delete.add_element( "contact:delete", { "xmlns:contact" => "urn:ietf:params:xml:ns:contact-1.0",
                                                             "xsi:schemaLocation" => "urn:ietf:params:xml:ns:contact-1.0 contact-1.0.xsd" } )

    contact_id = contact_delete.add_element "contact:id"
    contact_id.text = id
 end
end

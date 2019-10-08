class KonoEppTransferDomain < KonoEppCommand
  def initialize( name, authinfo, op )
    super( nil, nil )

    command = root.elements['command']
    transfer = command.add_element( "transfer", { "op" => op } )

    domain_transfer = transfer.add_element( "domain:transfer", { "xmlns:domain" => "urn:ietf:params:xml:ns:domain-1.0",
                                            "xsi:schemaLocation" => "urn:ietf:params:xml:ns:domain-1.0 domain-1.0.xsd" } )

    domain_name = domain_transfer.add_element "domain:name"
    domain_name.text = name

    domain_authinfo = domain_transfer.add_element "domain:authInfo"
    domain_pw = domain_authinfo.add_element "domain:pw"

    domain_pw.text = authinfo
  end
end

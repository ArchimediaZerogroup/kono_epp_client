class KonoEppCreateDomain < KonoEppCommand
  def initialize( options )
    super( nil, nil )

    command = root.elements['command']
    create = command.add_element( "create" )


    domain_create = create.add_element( "domain:create", { "xmlns:domain" => "urn:ietf:params:xml:ns:domain-1.0",
                                                           "xsi:schemaLocation" => "urn:ietf:params:xml:ns:domain-1.0 domain-1.0.xsd" } )

    name = domain_create.add_element "domain:name"
    name.text = options[:name]

    domain_ns = domain_create.add_element "domain:ns"

    options[:nameservers].each do |ns|
      host_attr = domain_ns.add_element "domain:hostAttr"
      host_name = host_attr.add_element "domain:hostName"

      host_name.text = ns[0]

      # FIXME IPv6
      if ns[1]
        host_addr = host_attr.add_element "domain:hostAddr", {"ip" => "v4"}
        host_addr.text = ns[1]
      end
    end

    domain_registrant = domain_create.add_element "domain:registrant"
    domain_registrant.text = options[:registrant]

    domain_contact = domain_create.add_element "domain:contact", { "type" => "admin" }
    domain_contact.text = options[:admin]

    domain_contact = domain_create.add_element "domain:contact", { "type" => "tech" }
    domain_contact.text = options[:tech]

    domain_authinfo = domain_create.add_element "domain:authInfo"

    domain_pw = domain_authinfo.add_element "domain:pw"
    domain_pw.text = options[:authinfo]
  end
end

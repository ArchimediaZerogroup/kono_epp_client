module KonoEppClient::Commands
  class UpdateDomain < Command
    def initialize(options)
      super(nil, nil)

      command = root.elements['command']
      update = command.add_element("update")

      domain_update = update.add_element("domain:update", {"xmlns:domain" => "urn:ietf:params:xml:ns:domain-1.0",
                                                           "xsi:schemaLocation" => "urn:ietf:params:xml:ns:domain-1.0 domain-1.0.xsd"})

      name = domain_update.add_element "domain:name"
      name.text = options[:name]

      if not options[:add_nameservers].blank? or options[:add_admin] or options[:add_tech] or options[:add_status]
        # <domain:add>
        domain_add = domain_update.add_element "domain:add"

        unless options[:add_nameservers].blank?
          domain_add_ns = domain_add.add_element "domain:ns"

          options[:add_nameservers].each do |ns|
            host_attr = domain_add_ns.add_element "domain:hostAttr"
            host_name = host_attr.add_element "domain:hostName"

            host_name.text = ns[0]

            # FIXME IPv6
            if ns[1]
              host_addr = host_attr.add_element "domain:hostAddr", {"ip" => "v4"}
              host_addr.text = ns[1]
            end
          end
        end

        if options[:add_admin]
          domain_contact = domain_add.add_element "domain:contact", {"type" => "admin"}
          domain_contact.text = options[:add_admin]
        end

        if options[:add_status]
          domain_add.add_element "domain:status", {"s" => options[:add_status]}
        end

        if options[:add_tech]
          domain_contact = domain_add.add_element "domain:contact", {"type" => "tech"}
          domain_contact.text = options[:add_tech]
        end
      end

      if not options[:remove_nameservers].blank? or options[:remove_admin] or options[:remove_tech] or options[:remove_status]
        # <domain:rem>
        domain_remove = domain_update.add_element "domain:rem"

        unless options[:remove_nameservers].blank?
          domain_remove_ns = domain_remove.add_element "domain:ns"

          options[:remove_nameservers].each do |ns_name|
            host_attr = domain_remove_ns.add_element "domain:hostAttr"
            host_name = host_attr.add_element "domain:hostName"

            host_name.text = ns_name
          end
        end

        if options[:remove_admin]
          domain_contact = domain_remove.add_element "domain:contact", {"type" => "admin"}
          domain_contact.text = options[:remove_admin]
        end

        if options[:remove_status]
          domain_remove.add_element "domain:status", {"s" => options[:remove_status]}
        end

        if options[:remove_tech]
          domain_contact = domain_remove.add_element "domain:contact", {"type" => "tech"}
          domain_contact.text = options[:remove_tech]
        end
      end

      # <domain:chg>
      if options[:auth_info]
        domain_change = domain_update.add_element "domain:chg"

        if options[:registrant]
          domain_registrant = domain_change.add_element "domain:registrant"
          domain_registrant.text = options[:registrant]
        end

        domain_authinfo = domain_change.add_element "domain:authInfo"

        domain_pw = domain_authinfo.add_element "domain:pw"
        domain_pw.text = options[:auth_info]
      end

      if options[:restore]
        command.add_element("extension").tap do |ext|
          ext.add_element("rgp:update", {"xmlns:rgp" => "urn:ietf:params:xml:ns:rgp-1.0",
                                         "xsi:schemaLocation" => "urn:ietf:params:xml:ns:rgp-1.0 rgp-1.0.xsd"}).
            add_element("rgp:restore", {"op" => "request"})
        end
      end
      # TODO: Registrant

      if options[:dns_sec_data] and options[:dns_sec_data].any?
        extension = command.elements['extension'] || command.add_element("extension")

        create_list = extension.add_element("secDNS:update", {"xmlns:secDNS"=> "urn:ietf:params:xml:ns:secDNS-1.1"})

        options[:dns_sec_data].each do |d|
          create_list.add_element(d)
        end
      end

    end
  end
end

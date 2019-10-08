class KonoEppCreateContact < KonoEppCommand
  def initialize( options )
    super( nil, nil )

    command = root.elements['command']

    create = command.add_element "create"

    contact_create = create.add_element( "contact:create", { "xmlns:contact" => "urn:ietf:params:xml:ns:contact-1.0",
                                                             "xsi:schemaLocation" => "urn:ietf:params:xml:ns:contact-1.0 contact-1.0.xsd" } )

    puts options
    id = contact_create.add_element "contact:id"
    id.text = options[:id]

    postal_info = contact_create.add_element "contact:postalInfo", { "type" => "loc" }

    name = postal_info.add_element "contact:name"
    name.text = options[:name]

    unless options[:organization].blank?
      organization = postal_info.add_element "contact:org"
      organization.text = options[:organization]
    end

    addr = postal_info.add_element "contact:addr"

    unless options[:street].blank?
      street = addr.add_element "contact:street"
      street.text = options[:street]
    end

    city = addr.add_element "contact:city"
    city.text = options[:city]

    unless options[:state].blank?
      state = addr.add_element "contact:sp"
      state.text  = options[:state]
    end

    unless options[:postal_code].blank?
      postal_code = addr.add_element "contact:pc"
      postal_code.text = options[:postal_code]
    end

    country_code = addr.add_element "contact:cc"
    country_code.text = options[:country_code]

    if options[:voice]
      voice = contact_create.add_element "contact:voice"
      voice.text = options[:voice]
    end

    if options[:fax]
      fax = contact_create.add_element "contact:fax"
      fax.text = options[:fax]
    end

    email = contact_create.add_element "contact:email"
    email.text = options[:email]

    auth_info = contact_create.add_element "contact:authInfo"
    pw = auth_info.add_element "contact:pw"
    pw.text = options[:auth_info]

    # FIXME
    extension = command.add_element "extension"
    extension_create = extension.add_element "extcon:create", { "xmlns:extcon"       => 'http://www.nic.it/ITNIC-EPP/extcon-1.0',
                                                                "xsi:schemaLocation" => 'http://www.nic.it/ITNIC-EPP/extcon-1.0 extcon-1.0.xsd' }

    publish = extension_create.add_element "extcon:consentForPublishing"
    publish.text = options[:publish] == "1" ? "true" : "false"

    if options[:is_registrant]
      extcon_registrant = extension_create.add_element "extcon:registrant"

      extcon_nationality = extcon_registrant.add_element "extcon:nationalityCode"
      extcon_nationality.text = options[:nationality]

      extcon_entity = extcon_registrant.add_element "extcon:entityType"
      extcon_entity.text = options[:entity_type]

      extcon_regcode = extcon_registrant.add_element "extcon:regCode"
      extcon_regcode.text = options[:reg_code]
    end
  end
end

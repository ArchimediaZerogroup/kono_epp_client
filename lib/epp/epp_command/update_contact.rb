class KonoEppUpdateContact < KonoEppCommand

  # TODO: Add and remove fields
  def initialize( options )
    super( nil, nil )

    command = root.elements['command']

    update = command.add_element "update"

    contact_update = update.add_element( "contact:update", { "xmlns:contact" => "urn:ietf:params:xml:ns:contact-1.0",
                                                             "xsi:schemaLocation" => "urn:ietf:params:xml:ns:contact-1.0 contact-1.0.xsd" } )

    id = contact_update.add_element "contact:id"
    id.text = options[:id]

    contact_chg = contact_update.add_element "contact:chg"

    unless options[:name].blank?              \
           and options[:organization].blank?  \
           and options[:address].blank?       \
           and options[:city].blank?          \
           and options[:state].blank?         \
           and options[:postal_code].blank?   \
           and options[:country].blank?

      postal_info = contact_chg.add_element "contact:postalInfo", { "type" => "loc" }

      unless options[:name].blank?
        name = postal_info.add_element "contact:name"
        name.text = options[:name]
      end

      unless options[:organization].blank?
        organization = postal_info.add_element "contact:org"
        organization.text = options[:organization]
      end

      # NOTE: city and country are REQUIRED
      unless options[:address].blank?         \
             and options[:city].blank?        \
             and options[:state].blank?       \
             and options[:postal_code].blank? \
             and options[:country].blank?

        addr = postal_info.add_element "contact:addr"

        unless options[:address].blank?
          street = addr.add_element "contact:street"
          street.text = options[:address]
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
        country_code.text = options[:country]
      end
    end

    if options[:voice]
      voice = contact_chg.add_element "contact:voice"
      voice.text = options[:voice]
    end

    if options[:fax]
      fax = contact_chg.add_element "contact:fax"
      fax.text = options[:fax]
    end

    if options[:email]
      email = contact_chg.add_element "contact:email"
      email.text = options[:email]
    end


    unless not options.has_key?( :publish ) \
           and options[:nationality].blank? \
           and options[:entity_type].blank? \
           and options[:reg_code].blank?

      # FIXME
      extension = command.add_element "extension"
      extension_update = extension.add_element "extcon:update", { "xmlns:extcon"       => 'http://www.nic.it/ITNIC-EPP/extcon-1.0',
                                                                  "xsi:schemaLocation" => 'http://www.nic.it/ITNIC-EPP/extcon-1.0 extcon-1.0.xsd' }
      if options.has_key?( :publish )
        publish = extension_update.add_element "extcon:consentForPublishing"
        publish.text = options[:publish]
      end

      if options[:becomes_registrant]
        extcon_registrant = extension_update.add_element "extcon:registrant"

        extcon_nationality = extcon_registrant.add_element "extcon:nationalityCode"
        extcon_nationality.text = options[:nationality]

        extcon_entity = extcon_registrant.add_element "extcon:entityType"
        extcon_entity.text = options[:entity_type]

        extcon_regcode = extcon_registrant.add_element "extcon:regCode"
        extcon_regcode.text = options[:reg_code]
      end
    end
  end
end

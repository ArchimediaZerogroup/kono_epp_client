module KonoEppClient::Commands
  class CheckContacts < Command
    def initialize(ids)
      super(nil, nil)

      command = root.elements['command']

      info = command.add_element "check"

      contact_check = info.add_element("contact:check", {"xmlns:contact" => "urn:ietf:params:xml:ns:contact-1.0"})

      ids.each do |t|
        contact_id = contact_check.add_element "contact:id"
        contact_id.text = t
      end

    end
  end
end

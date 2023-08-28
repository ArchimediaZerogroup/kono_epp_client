class KonoEppCheckContacts < KonoEppCommand
  def initialize
    super(nil, nil)

    command = root.elements['command']

    info = command.add_element "check"

    contact_check = info.add_element("contact:check", {"xmlns:contact" => "urn:ietf:params:xml:ns:contact-1.0"})

    ["mm001",
     "mb001",
     "cl001",
     "bb001"].each do |t|
      contact_id = contact_check.add_element "contact:id"
      contact_id.text = t
    end

  end
end

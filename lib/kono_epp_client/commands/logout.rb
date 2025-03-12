module KonoEppClient::Commands
  class Logout < Command
    def initialize(id = nil, password = nil)
      super(nil, nil)

      command = root.elements['command']
      command.add_element("logout")

      command.add_element("clTRID").text = "ABC-12345"
    end
  end
end

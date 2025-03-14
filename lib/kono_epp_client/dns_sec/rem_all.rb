# frozen_string_literal: true

module KonoEppClient::DnsSec
  class RemAll < REXML::Element
    def initialize
      super("secDNS:rem")
      self.add_element("secDNS:all").text="true"
    end
  end
end

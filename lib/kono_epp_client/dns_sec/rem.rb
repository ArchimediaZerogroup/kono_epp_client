# frozen_string_literal: true

module KonoEppClient::DnsSec
  class Rem < REXML::Element
    def initialize(*ds_datas)
      super("secDNS:rem")

      ds_datas.each do |ds_data|
        self.add_element ds_data
      end

    end
  end
end

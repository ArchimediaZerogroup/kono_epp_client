# frozen_string_literal: true

module KonoEppClient::DnsSec
  class Add < REXML::Element
    def initialize(*ds_datas)
      super("secDNS:add")

      ds_datas.each do |ds_data|
        self.add_element ds_data
      end
    end
  end
end

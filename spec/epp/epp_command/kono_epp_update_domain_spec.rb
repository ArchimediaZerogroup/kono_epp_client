# frozen_string_literal: true

RSpec.describe KonoEppUpdateDomain do

  let(:options) do
    {
      name: 'example.com',
      # add_nameservers: [['ns1.example.com', '192.168.1.1']],
      # add_admin: 'admin_contact',
      # add_tech: 'tech_contact',
      # remove_nameservers: ['ns2.example.com'],
      # remove_admin: 'admin_contact_to_remove',
      # remove_tech: 'tech_contact_to_remove',
      # auth_info: 'my_auth_info',
      # registrant: 'new_registrant'
    }
  end

  include_context "like epp command"

  let(:instance) {
    KonoEppUpdateDomain.new(options)
  }

  it "contiene il nome del dominio" do
    expect(rendered.to_s).to have_tag("update>name", text: options[:name])
  end

  context "update nameservers" do
    let(:options) {
      super().merge({
                      add_nameservers: [
                        ['ns1.example.com', '192.168.1.1'],
                        ['ns3.example.com']
                      ],
                      remove_nameservers: ['ns2.example.com'],
                    })
    }
    it "aggiunge e rimuove ns", snapshot: 'xml' do
      expect(rendered.to_s.downcase).to have_tag("update>add>ns") do
        with_tag("hostattr") do
          with_tag("hostname", text: 'ns1.example.com')
          with_tag("hostaddr", text: '192.168.1.1')
        end
      end
      expect(rendered.to_s.downcase).to have_tag("update>add>ns") do
        with_tag("hostattr") do
          with_tag("hostname", text: 'ns3.example.com')
          without_tag("hostaddr",text:"")
        end
      end
      expect(rendered.to_s.downcase).to have_tag("update>rem>ns") do
        with_tag("hostattr") do
          with_tag("hostname", text: 'ns2.example.com')
        end
      end
    end
  end

  context "update contacts", snapshot: 'xml' do
    let(:options) {
      super().merge({
                      add_admin: "AAA1",
                      add_tech: "TTT1",
                      remove_admin: "AAA2",
                      remove_tech: "TTT2"
                    })
    }
    it "cambia ADMIN_TECH", snapshot: 'xml' do
      expect(rendered.to_s.downcase).to have_tag("update>add>contact", with: {type: "admin"}, text: options[:add_admin].downcase)
      expect(rendered.to_s.downcase).to have_tag("update>rem>contact", with: {type: "admin"}, text: options[:remove_admin].downcase)
      expect(rendered.to_s.downcase).to have_tag("update>add>contact", with: {type: "tech"}, text: options[:add_tech].downcase)
      expect(rendered.to_s.downcase).to have_tag("update>rem>contact", with: {type: "tech"}, text: options[:remove_tech].downcase)
    end
  end
  context "update status" do
    let(:options) {
      super().merge({
                      add_status: "clientTransferProhibited",
                      remove_status: "clientHold",
                    })
    }
    it "cambia status", snapshot: 'xml' do
      expect(rendered.to_s.downcase).to have_tag("update>add>status", with: {s: options[:add_status].downcase})
      expect(rendered.to_s.downcase).to have_tag("update>rem>status", with: {s: options[:remove_status].downcase})
    end
  end

  context "restore" do
    let(:options) {
      super().merge({
                      restore: true
                    })
    }
    it "esiste l'estensione di restore",snapshot: 'xml' do
      expect(rendered.to_s.downcase).to have_tag("extension>update>restore", with: {op: "request"})
    end
  end

  context "update auth_info" do
    let(:options) {
      super().merge({
                      auth_info: "AUTH12-!DSRTG"
                    })
    }
    it "cambia AUTH_INFO", snapshot: "xml" do
      expect(rendered.to_s.downcase).to have_tag("update>chg") do
        with_tag("authinfo>pw", text: options[:auth_info].downcase)
        without_tag("registrant")
      end
    end

    context "con nuovo registrant" do
      let(:options) {
        super().merge({
                        registrant: "R0001"
                      })
      }
      it "cambia REGISTRANT", snapshot: "xml" do
        expect(rendered.to_s.downcase).to have_tag("update>chg>registrant", text: options[:registrant].downcase)
      end
    end
  end

end
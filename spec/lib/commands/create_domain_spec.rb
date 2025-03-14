# frozen_string_literal: true

RSpec.describe KonoEppClient::Commands::CreateDomain do
  include_context "like epp command"

  let(:opts) {
    {
      name: 'architest.it',
      period: 1,
      nameservers:
        [["ns.test.it", "192.168.100.10"],
         ["ns2.test.it", "192.168.100.20"],
         ["ns3.foo.com"]],
      # contacts
      registrant: "RRR12",
      admin: "AAAA12",
      tech: "TTT12",
      authinfo: "WWW-test-it"
    }
  }

  let(:instance) { KonoEppClient::Commands::CreateDomain.new(opts) }

  it "create", snapshot: "xml" do
    expect(rendered.to_s).to have_tag("ns")
    expect(rendered.to_s.downcase).to have_tag("hostattr")
    expect(rendered.to_s.downcase).to have_tag("ns hostattr") do
      with_tag("hostname", text: "ns2.test.it")
      with_tag("hostaddr", text: "192.168.100.20", with: {ip: "v4"})
    end
    expect(rendered.to_s.downcase).to have_tag("ns hostattr") do
      with_tag("hostname", text: "ns.test.it")
      with_tag("hostaddr", text: "192.168.100.10", with: {ip: "v4"})
    end
    expect(rendered.to_s.downcase).not_to have_tag("ns hostaddr", with: {ip: 'v4'}, text: "")
  end

  context "create with ds_data" do

    let(:opts) {
      super().merge(dns_sec_data: [create(:ds_data, key_tag: 9657)])
    }

    it "build extensions", snapshot: "xml" do
      expect(rendered.to_s).to have_tag("extension>create>dsdata>keytag", text: 9657)
    end

  end

end
RSpec.describe KonoEppClient::DnsSec::DsData do

  let(:instance) {
    KonoEppClient::DnsSec::RemAll.new
  }

  it "#to_s" do
    expect(instance.to_s).to match(file_fixture("dns_sec/rem_all.xml").read.gsub(/[[:space:]]/, ''))
  end

end

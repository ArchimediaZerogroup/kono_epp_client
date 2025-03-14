RSpec.describe KonoEppClient::DnsSec::DsData do

  let(:instance) {
    KonoEppClient::DnsSec::Add.new(
      create(:ds_data,key_tag:"1234"),
      create(:ds_data,key_tag:"4321"),
    )
  }

  it "#to_s" do
    expect(instance.to_s).to match(xml_fixture("dns_sec/add.xml"))
  end

end

RSpec.describe KonoEppClient::DnsSec::DsData do

  let(:instance) {
    KonoEppClient::DnsSec::DsData.new(123, :dsa_sha_1, :sha_1, "digest")
  }

  it "valid instance" do
    expect(instance).to have_attributes(key_tag: 123, alg: 3, digest_type: 1, digest: "digest")
  end

  describe "instantiate" do
    where(:case_name, :values, :expectation) do
      [
        [
          :key_tag_to_low,
          [-1, :dsa_sha_1, :sha_1, "digest"],
          "Invalid key tag -1, should be 0<=key_tag<=65535"
        ], [
          :key_tag_to_hight,
          [1_000_000, :dsa_sha_1, :sha_1, "digest"],
          "Invalid key tag 1000000, should be 0<=key_tag<=65535"
        ], [
          :digest_type,
          [123, :dsa_sha_1, :non_presente, "digest"],
          "Invalid digest type non_presente"
        ], [
          :alg,
          [1_000_000, :non_presente, :sha_1, "digest"],
          "Invalid alg non_presente"
        ],
      ]
    end

    with_them do
      it { expect { KonoEppClient::DnsSec::DsData.new(*values) }.to raise_error(expectation) }
    end
  end

  it "#to_s" do
    expect(instance.to_s).to match(xml_fixture("dns_sec/ds_data.xml"))
  end

end

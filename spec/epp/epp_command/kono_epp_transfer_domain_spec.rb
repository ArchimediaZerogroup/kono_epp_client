# frozen_string_literal: true

RSpec.describe KonoEppTransferDomain do

  include_context "like epp command"

  let(:instance) do
    described_class.new("test.it", "wee-12-sd", 'request')
  end

  it "construct", snapshot: 'xml' do
    expect(rendered.to_s).to have_tag("epp>command>transfer", with: {op: "request"}, count: 1) do
      with_tag("transfer>name", text: "test.it")
      with_tag("transfer>authinfo>pw", text: "wee-12-sd")
    end
  end

  context "con extension" do

    let(:instance) do
      described_class.new("test.it", "wee-12-sd", 'request',
                          extension: {new_registrant: "xx123fd", new_auth_info: "abc-sd934-sd"})
    end

    it "construct", snapshot: 'xml' do
      expect(rendered.to_s).to have_tag("epp>command>extension>trade>transfertrade") do
        with_tag("newregistrant", text: "xx123fd")
        with_tag("newauthinfo>pw", text: "abc-sd934-sd")
      end
    end
  end

end
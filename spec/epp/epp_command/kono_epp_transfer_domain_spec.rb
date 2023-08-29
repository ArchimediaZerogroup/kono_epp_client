# frozen_string_literal: true

RSpec.describe KonoEppTransferDomain do

  include_context "like epp command"

  let(:instance) do
    described_class.new("test.it", "wee-12-sd", 'request')
  end

  it "construct",snapshot: 'xml' do
    expect(rendered.to_s).to have_tag("epp>command>transfer", with: {op: "request"}, count: 1) do
      with_tag("transfer>name", text: "test.it")
      with_tag("transfer>authinfo>pw", text: "wee-12-sd")
    end
  end

end
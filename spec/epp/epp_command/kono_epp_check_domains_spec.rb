# frozen_string_literal: true

RSpec.describe KonoEppCheckDomains do
  include_context "like epp command"

  let(:instance) do
    described_class.new("test.it","wow.it")
  end

  it "construct", snapshot: "xml" do
    expect(rendered.to_s).to have_tag("epp>command>check>check") do
        with_tag("name", text: "test.it")
        with_tag("name", text: "wow.it")
    end
  end
end
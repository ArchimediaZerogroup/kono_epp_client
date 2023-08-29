# frozen_string_literal: true
RSpec.describe KonoEppCheckContacts do

  let(:ids){
    ["mm001",
     "mb001",
     "cl001",
     "bb001"]
  }

  include_context "like epp command"

  let(:instance) {
    described_class.new(ids)
  }

  it "construct", snapshot: 'xml' do
    expect(rendered.to_s).to have_tag("epp>command>check>check") do
      ids.each do |t|
        with_tag("id", text: t)
      end
    end
  end

end
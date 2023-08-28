# frozen_string_literal: true
RSpec.describe KonoEppCheckContacts do

  include_context "like epp command"


  it "construct", snapshot: 'xml' do
    expect(rendered.to_s).to have_tag("epp>command>check>check") do
      ["mm001",
       "mb001",
       "cl001",
       "bb001"].each do |t|
        with_tag("id", text: t)
      end
    end
  end

end
# frozen_string_literal: true
RSpec.describe KonoEppCheckContacts do

  let(:instance) {
    described_class.new
  }

  let(:raw_rendered_content) {
    instance.to_s
  }
  let(:rendered) {
    x = Nokogiri::XML(raw_rendered_content)
    x.remove_namespaces! # FIXME non capisco come funzioni la ricerca con namespace
    x
  }

  it "construct", snapshot: true do
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
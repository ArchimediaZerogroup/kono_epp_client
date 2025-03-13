RSpec.shared_context "like epp command" do

  let(:instance) {
   described_class.new
  }

  let(:raw_rendered_content) {
    instance.to_s
  }
  let(:rendered) {
    x = Nokogiri::XML(raw_rendered_content)
    x.remove_namespaces! # La ricerca con namespace deve essere fatta con have_xpath e il passaggio di namespace
    x
  }
end
require "rspec/snapshot"
require "active_support/core_ext/string"


def first_parent_example_group(metadata)
  parent = metadata[:parent_example_group] || metadata[:example_group]
  return metadata if parent.nil?
  first_parent_example_group(parent)
end


RSpec.configure do |config|

  config.snapshot_dir = "spec/fixtures/snapshots"

  config.after(:each, snapshot: true) do |example|
    extension=nil
    extension = ".#{example.metadata[:snapshot]}" unless example.metadata[:snapshot] === true
    described_class = first_parent_example_group(example.metadata)[:described_class]
    class_name = described_class.name.underscore
    test_name = example.metadata[:full_description].gsub(described_class.name, "").tr(" ", "_")
    raise "component snapshot has no content" if raw_rendered_content.nil? or raw_rendered_content.empty?
    str_content = raw_rendered_content
    if extension == ".xml"
      str_content = Nokogiri.XML(str_content).to_xml
    end
    expect(str_content).to match_snapshot("#{class_name}/#{test_name}#{extension}")
  end

end
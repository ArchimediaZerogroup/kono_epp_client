require "rspec/snapshot"
require "active_support/core_ext/string"
RSpec.configure do |config|

  config.snapshot_dir = "spec/fixtures/snapshots"

  config.after(:each, snapshot: true) do |example|
    class_name = example.metadata[:described_class].name.underscore
    test_name = example.metadata[:full_description].gsub(example.metadata[:described_class].name, "").tr(" ", "_")
    raise "component snapshot has no content" if raw_rendered_content.blank?
    expect(raw_rendered_content).to match_snapshot("#{class_name}/#{test_name}")
  end

end
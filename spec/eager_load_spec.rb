# frozen_string_literal: true
RSpec.describe "Zeitwerk" do
  it "eager loads all files" do
    expect { Zeitwerk::Loader.eager_load_all }.not_to raise_error
  end
end

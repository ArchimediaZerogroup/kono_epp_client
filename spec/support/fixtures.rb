module FixturesReader
  def file_fixture(filename)
    fixuture_path =  File.expand_path('../fixtures', File.dirname(__FILE__))
    File.open("#{fixuture_path}/#{filename}", 'r')
  end
end

RSpec.configure do |config|
  config.include FixturesReader
end

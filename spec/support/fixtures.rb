module FixturesReader
  def file_fixture(filename)
    fixuture_path =  File.expand_path('../fixtures', File.dirname(__FILE__))
    File.open("#{fixuture_path}/#{filename}", 'r')
  end

  ##
  # Stessa cosa del file_fixture ma elimina tutti gli spazi dal file xml
  def xml_fixture(filename)
    file_fixture(filename).read.gsub(/[[:space:]]/, '')
  end
end

RSpec.configure do |config|
  config.include FixturesReader
end

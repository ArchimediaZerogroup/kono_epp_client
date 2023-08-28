# frozen_string_literal: true
require 'rexml/document'

RSpec.describe KonoEppCommand do
  it 'generates a valid XML document with the expected structure' do
    xml_document = KonoEppCommand.new
    expect(xml_document).to be_a(REXML::Document)
    expect(xml_document.to_s).to include("xsi:schemaLocation='urn:ietf:params:xml:ns:epp-1.0 epp-1.0.xsd'")
    expect(xml_document.to_s).to include("xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'")
    expect(xml_document.to_s).to have_tag("epp",with:{
      xmlns:"urn:ietf:params:xml:ns:epp-1.0"
    }) do
      have_tag("command",count:1)
    end
  end
end

# frozen_string_literal: true

module KonoEppClient::Exceptions
  class ErrorResponse < StandardError #:nodoc:
    attr_accessor :response_xml, :response_code, :reason_code, :message

    # Generic EPP exception. Accepts a response code and a message
    def initialize(attributes = {})
      @response_xml = attributes[:xml]
      @response_code = attributes[:response_code]
      @reason_code = attributes[:reason_code]
      @message = attributes[:message]
    end

    def to_s
      "#{@message} (reason: #{@reason_code} code: #{@response_code})"
    end
  end
end
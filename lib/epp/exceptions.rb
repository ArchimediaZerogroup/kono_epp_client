class KonoEppErrorResponse < StandardError #:nodoc:
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

class KonoEppAuthenticationPasswordExpired < KonoEppErrorResponse ; end
class KonoEppLoginNeeded < KonoEppErrorResponse ; end

##
# Errore NIC:
# 2304=Object status prohibits operation 9022=Domain has status clientTransferProhibited
class KonoEppDomainHasStatusCliTransProhibited < KonoEppErrorResponse; end

##
# Errore NIC:
# 2304=Object status prohibits operation 9026=Domain has status clientUpdateProhibited
class KonoEppDomainHasStatusClientUpdateProhibited < KonoEppErrorResponse; end

module KonoEppClient::Exceptions
  class AuthenticationPasswordExpired < ErrorResponse; end

  class LoginNeeded < ErrorResponse; end

  ##
  # Errore NIC:
  # 2304=Object status prohibits operation 9022=Domain has status clientTransferProhibited
  class DomainHasStatusCliTransProhibited < ErrorResponse; end

  ##
  # Errore NIC:
  # 2304=Object status prohibits operation 9026=Domain has status clientUpdateProhibited
  class DomainHasStatusClientUpdateProhibited < ErrorResponse; end
end
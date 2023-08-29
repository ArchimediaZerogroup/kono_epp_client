class KonoEppTransferDomain < KonoEppCommand
  def initialize(name, authinfo, op, extension: nil)
    super(nil, nil)

    command = root.elements['command']
    transfer = command.add_element("transfer", {"op" => op})
    # FIXME dovremmo controllare che le possibili opzioni di OP sono  'request', 'cancel', 'approve', 'reject', 'query'

    domain_transfer = transfer.add_element("domain:transfer", {"xmlns:domain" => "urn:ietf:params:xml:ns:domain-1.0",
                                                               "xsi:schemaLocation" => "urn:ietf:params:xml:ns:domain-1.0 domain-1.0.xsd"})

    domain_name = domain_transfer.add_element "domain:name"
    domain_name.text = name

    domain_authinfo = domain_transfer.add_element "domain:authInfo"
    domain_pw = domain_authinfo.add_element "domain:pw"

    domain_pw.text = authinfo

    ## Questa estensione è per Modifica del Registrar con contestuale modifica del Registrante
    if extension

      ext_elm = command.add_element "extension"
      ext_trade = ext_elm.add_element "extdom:trade", {"xmlns:extdom"=>"http://www.nic.it/ITNIC-EPP/extdom-2.0",
                                                         "xsi:schemaLocation" => "http://www.nic.it/ITNIC-EPP/extdom-2.0 extdom-2.0.xsd"}

      transfer_trade = ext_trade.add_element "extdom:transferTrade"
      transfer_trade.add_element("extdom:newRegistrant").text = extension[:new_registrant] if extension[:new_registrant]
      if extension[:new_auth_info]
        transfer_trade.add_element("extdom:newAuthInfo").add_element("extdom:pw").tap{|x|x.text=extension[:new_auth_info]}
      end

    end

  end
end

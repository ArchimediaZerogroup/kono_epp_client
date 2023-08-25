# Gem and other dependencies
require 'rubygems'
require 'openssl'
require 'socket'
require 'active_support'
require 'rexml/document'

# Package files
require File.dirname(__FILE__) + '/require_parameters.rb'
require File.dirname(__FILE__) + '/epp/server.rb'
require File.dirname(__FILE__) + '/epp/exceptions.rb'

require File.dirname(__FILE__) + '/epp/transport.rb'
require File.dirname(__FILE__) + '/epp/transport/tcp.rb'
require File.dirname(__FILE__) + '/epp/transport/http.rb'

require File.dirname(__FILE__) + '/epp/epp_command.rb'
require File.dirname(__FILE__) + '/epp/epp_command/hello.rb'
require File.dirname(__FILE__) + '/epp/epp_command/login.rb'
require File.dirname(__FILE__) + '/epp/epp_command/logout.rb'
require File.dirname(__FILE__) + '/epp/epp_command/poll.rb'
require File.dirname(__FILE__) + '/epp/epp_command/create_contact.rb'
require File.dirname(__FILE__) + '/epp/epp_command/create_domain.rb'
require File.dirname(__FILE__) + '/epp/epp_command/info_contact.rb'
require File.dirname(__FILE__) + '/epp/epp_command/info_domain.rb'
require File.dirname(__FILE__) + '/epp/epp_command/delete_contact.rb'
require File.dirname(__FILE__) + '/epp/epp_command/delete_domain.rb'
require File.dirname(__FILE__) + '/epp/epp_command/transfer_domain.rb'
require File.dirname(__FILE__) + '/epp/epp_command/update_contact.rb'
require File.dirname(__FILE__) + '/epp/epp_command/update_domain.rb'

module KonoEppClient #:nodoc:
end

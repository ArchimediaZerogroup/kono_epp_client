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

# load di tutti i comandi presenti in epp_command
Dir.glob(File.dirname(__FILE__) + '/epp/epp_command/*.rb').each do |f|
  require f
end

module KonoEppClient #:nodoc:
end

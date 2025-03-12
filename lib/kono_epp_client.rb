# Gem and other dependencies
require 'rubygems'
require 'openssl'
require 'socket'
require 'active_support/all'
require 'rexml/document'

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module KonoEppClient #:nodoc:
end

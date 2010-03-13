$:.unshift(File.dirname(__FILE__) + '/lib')

require 'reuben'
require 'store/adapters'

use Rack::ShowExceptions
run RG::Reuben.new RG::Store::Adapters::MemcachedAdapter, 'localhost:11211'
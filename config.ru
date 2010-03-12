$:.unshift(File.dirname(__FILE__) + '/lib')

require 'reuben'
require 'reuben/adapters/memcached_adapter'

use Rack::ShowExceptions
run Rack::Reuben.new Reuben::Adapters::MemcachedAdapter, 'localhost:11211'
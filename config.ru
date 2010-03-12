require File.dirname(__FILE__) + '/lib/reuben.rb'

use Rack::ShowExceptions
run Rack::Reuben.new
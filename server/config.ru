use Rack::ShowExceptions

module Rack
  class Reuben
    
    def call(env)
      request = Rack::Request.new(env)
      return [200, {'Content-type' => 'text/plain'}, ['Hello World!']]
    end
    
  end
end

run Rack::Reuben.new
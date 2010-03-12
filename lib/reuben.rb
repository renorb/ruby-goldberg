module Rack
  class Reuben

    def initialize
      # cache = Memcached.new("localhost:11211")
    end
    
    def call(env)
      request = Rack::Request.new(env)
      
      out = case request.path
      when "/" # not sure what root should return
        "Nothing Here"
      when "/rubeme" # register a rube client
        "rubeme"
      else
        "Unknown"
      end
      
      return [200, {'Content-type' => 'text/plain'}, out]
    end
    
  end
end
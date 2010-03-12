# require 'redis'
require 'memcached'

module Rack
  class Reuben

    def initialize
      @cache = Memcached.new("localhost:11211") # setup memcached connection
    end
    
    def call(env)
      request = Rack::Request.new(env)
      
      out = case request.path
      when "/" # not sure what root should return
        "Nothing Here"
      when "/rubeme" # register a rube client
        if request.post?
          name = request.params["name"]
          rube = request.params["rube"]
          health = request.params["health"]
          begin
            @cache.set "#{name}_name", name
            @cache.set "#{name}_rube", rube
            @cache.set "#{name}_health", health
          rescue Memcached::NotFound
          end
          "registered name:#{name} rube url:#{rube} health url:#{health}"
        else
          "fail"
        end
      else
        "Unknown"
      end
      
      return [200, {'Content-type' => 'text/plain'}, out]
    end
    
  end
end
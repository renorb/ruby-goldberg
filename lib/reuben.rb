require 'sinatra/base'
require 'memcached'

module Rack
  class Reuben < Sinatra::Base

    def initialize
      @cache = Memcached.new("localhost:11211") # setup memcached connection
    end
    
    get "/" do # not sure what root should return
      "Nothing Here"
    end
    
    post "/rubeme" do # register a rube client
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
    end
      
    get "/check" do # "/check?test" will check if client named 'test' is registered
      begin
        result = @cache.get "#{request.GET}_name"
        "#{request.GET} is registered!!"
      rescue Memcached::NotFound
        "#{request.GET} not found"
      end
    end
    
  end
end
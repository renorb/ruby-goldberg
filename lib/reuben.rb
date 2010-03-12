require 'sinatra/base'
require 'erb'
require 'memcached'

module Rack
  class Reuben < Sinatra::Base

    def initialize
      @cache = Memcached.new("localhost:11211") # setup memcached connection
      begin
        @cache.get "keys" # see if keys array is set
      rescue Memcached::NotFound
        @cache.set "keys", [] # reset key array to empty array
      end
    end

    get "/rubes" do # get list of registered rube's
      keys = @cache.get "keys"
      "rubes: #{keys}"
    end

    get "/" do # not sure what root should return
      erb :index
    end

    post "/" do # kick off
      # process posted text - pass it to a random rube
    end

    post "/rubeme" do # register a rube client
      name   = params["name"]
      rube   = params["rube"]
      health = params["health"]

      @cache.set "#{name}_name", name
      @cache.set "#{name}_rube", rube
      @cache.set "#{name}_health", health

      keys = @cache.get "keys"
      keys << name
      @cache.set "keys", keys
      "registered name:#{name} rube url:#{rube} health url:#{health}"
    end

    get "/rubes" do # get list of registered rube's
      keys = @cache.get "keys"
      "rubes: #{keys}"
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

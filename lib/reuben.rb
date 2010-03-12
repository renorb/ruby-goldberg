require 'sinatra/base'
require 'erb'

module Rack
  class Reuben < Sinatra::Base

    # ==== Parameters
    # store: Class name which will be instantiated with +store_config+
    #        passed to the initializer. Defaults to Memcached
    #
    # store_config: Parameters passed to +store+'s
    #               initializer. Defaults to 'localhost:11211'
    #
    def initialize(store = nil, store_config = "localhost:11211")
      unless store
        require 'memcached'
        store = Memcached
      end

      @cache = store.new(store_config) # setup key-value store connection

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

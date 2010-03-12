require 'sinatra/base'
require 'erb'

module Rack
  class Reuben < Sinatra::Base

    # ==== Parameters
    # store: Class name which will be instantiated with +store_config+
    #        passed to the initializer.
    #
    # store_config: Parameters passed to +store+'s
    #               initializer. Optional.
    #
    def initialize(store, store_config = nil)

      if store_config
        @cache = store.new(store_config)
      else
        @cache = store.new
      end

      key = @cache.get "keys" # see if keys array is set

      unless key
        @cache.set "keys", [] # reset key array to empty array
      end
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

      @cache.set "#{name}_name", name
      @cache.set "#{name}_rube", rube

      keys = @cache.get "keys"
      keys << name
      @cache.set "keys", keys
      "registered name:#{name} rube url:#{rube}"
    end

    get "/rubes" do # get list of registered rube's
      keys = @cache.get "keys"
      "rubes: #{keys}"
    end

    get "/check" do # "/check?test" will check if client named 'test' is registered
      result = @cache.get "#{request.GET}_name"

      if result
        "#{request.GET} is registered!!"
      else
        "#{request.GET} not found"
      end
    end

  end
end

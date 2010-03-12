require 'sinatra/base'
require 'digest/md5'
require 'erb'
require 'json'

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

      unless @cache.get "keys"
        @cache.set "keys", [].to_json # reset key array to empty array
      end
    end

    get "/" do # not sure what root should return
      erb :index
    end

    post "/" do # kick off
      # process posted text - pass it to a random rube
    end

    post "/rubeme" do # register a rube client
      name = params["name"]
      desc = params["desc"]
      url  = params["url"]
      md5  = Digest::MD5.hexdigest(url)

      @cache.set "#{md5}_name", name
      @cache.set "#{md5}_desc", desc
      @cache.set "#{md5}_url", url

      keys = JSON.parse(@cache.get("keys"))
      keys << md5
      @cache.set "keys", keys.to_json
      "registered name:#{name} key:#{md5} url:#{url} desc:#{desc}"
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

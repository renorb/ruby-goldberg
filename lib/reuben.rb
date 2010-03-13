require 'sinatra/base'
require 'digest/md5'
require 'erb'
require 'json'
require 'curb'
require 'rube'

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
      package = params["package"]
      pkg_key = Digest::MD5.hexdigest(package + Time.now.to_s)
      list = get_random_rube_list
      @cache.set pkg_key, list
      # verify rube url is up
      c = Curl::Easy.perform(rube_url)
      if c.response_code == 200
        # post to first rube
        c = Curl::Easy.http_post(rube_url,
                                 Curl::PostField.content('package', package),
                                 Curl::PostField.content('next_url', next_url))
        "kicked off #{package}"
      else
      end
    end

    post "/rubeme" do # register a rube client
      # name = params["name"]
      # desc = params["desc"]
      # url  = params["url"]
      # md5  = Digest::MD5.hexdigest(url)
      rube = Rube.init(params)

      # @cache.set "#{md5}_name", rube.name
      # @cache.set "#{md5}_desc", rube.desc
      # @cache.set "#{md5}_url", rube.url
      rube.store(@cache)

      keys = JSON.parse(@cache.get("keys"))
      keys << rube.md5
      @cache.set "keys", keys.to_json
      "registered name:#{rube.name} key:#{rube.md5} url:#{rube.url} desc:#{rube.desc}"
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

    private
    
    def get_random_rube_list
      # FIXME - needs some random selection/ordering
      JSON.parse(@cache.get "keys")
    end
    
  end
end

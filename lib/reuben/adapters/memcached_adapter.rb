require 'reuben/adapters/abstract_adapter'

module Reuben #:nodoc:
  module Adapters #:nodoc:

    class MemcachedAdapter < AbstractAdapter

      def initialize(config)
        require 'memcached'
        @cache = Memcached.new(config)
      end

      def get(key)
        @cache.get key
      rescue Memcached::NotFound
        nil
      end

      def set(key, value)
        @cache.set key, value
      end

    end

  end
end

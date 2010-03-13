module RG #:nodoc:
  module Adapters #:nodoc:

    class MemoryAdapter < AbstractAdapter

      def initialize( config = {} )
        @cache = {}
      end
    
      # ==== Parameters
      # key<String>:: key to lookup in the store
      #
      # ==== Returns
      # String if key found, NilClass on cache miss
      #
      def get(key)
        @cache[key]
      end

      # ==== Parameters
      # key<String>:: key to store +value+ under
      # value<String>:: value to store under +key+
      #
      def set(key, value)
        @cache[key] = value
      end

    end
    
  end
end
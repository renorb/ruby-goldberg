module Reuben #:nodoc:
  module Adapters #:nodoc:

    class AbstractAdapter

      # ==== Parameters
      # key<String>:: key to lookup in the store
      #
      # ==== Returns
      # String if key found, NilClass on cache miss
      #
      def get(key)
        raise NotImplementedError
      end

      # ==== Parameters
      # key<String>:: key to store +value+ under
      # value<String>:: value to store under +key+
      #
      def set(key, value)
        raise NotImplementedError
      end

    end

  end
end

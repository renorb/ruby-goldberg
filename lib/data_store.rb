require 'forwardable'
require 'adapters'

module RG #:nodoc:
  class DataStore #:nodoc:
    extend Forwardable

    attr_accessor :backend

    def_delegators :@backend, :get, :set
    
    # ==== Parameters
    # backend<Symbol>:: name of backend to initialize
    #  or
    # backend<Object>:: something that responds to get and set
    #
    def initialize( backend = nil, config = {} )
      backend ||= :memory
      @backend = if backend.respond_to?(:get)
        backend
      else
        begin
          adapter = RG::Adapters.const_get("#{backend.to_s.capitalize}Adapter")
          adapter.new(config)
        rescue LoadError
          Raise "Cannot find the backend #{backend}"
        end
      end
    end
    
  end
end
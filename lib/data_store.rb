require 'forwardable'
require 'adapters'

module RG #:nodoc:
  class DataStore #:nodoc:
    extend Forwardable

    attr_accessor :backend, :adapter

    def_delegators :@adapter, :get, :set
    
    # ==== Parameters
    # backend<Symbol>:: name of backend to initialize
    #
    def initialize( backend = nil, config = {} )
      backend ||= :memory
      
      begin
        adapter = RG::Adapters.const_get("#{backend.to_s.capitalize}Adapter")
        @adapter = adapter.new(config)
      rescue LoadError
        Raise "Cannot find the backend #{backend}"
      end
      
    end
    
  end
end
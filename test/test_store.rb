require 'helper'

class TestStore < Test::Unit::TestCase
  
  def test_store_defaults_to_memory_store
    store = RG::DataStore.new
    assert_equal RG::Adapters::MemoryAdapter, store.backend.class
  end
  
end
require 'rubygems'
require 'test/unit'
require 'rack/test'

require 'reuben'
require 'reuben/adapters/abstract_adapter'

class TestAdapter < Reuben::Adapters::AbstractAdapter

  def initialize
    @cache = {}
  end

  def get(key)
    @cache[key]
  end

  def set(key, value)
    @cache[key] = value
  end

end

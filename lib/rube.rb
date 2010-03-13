require 'reuben'

# Rube client attributes
module RG
  class Rube

    attr_accessor :md5, :name, :desc, :url
  
    def self.init(params)
      new(params)
    end

    def initialize( params = nil )
      if params
        self.name = params["name"]
        self.desc = params["desc"]
        self.url  = params["url"]
        self.md5  = Digest::MD5.hexdigest(self.url)
      end
    end
    
    def data_store
      Reuben.store
    end
    
    def store
      data_store.set "#{md5}_name", self.name
      data_store.set "#{md5}_desc", self.desc
      data_store.set "#{md5}_url", self.url
    end
    
  end
end
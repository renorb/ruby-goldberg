# Rube client attributes
class Rube < Object
  
  attr_accessor :md5, :name, :desc, :url
  
  def self.init(params)
    new.init_from_params(params)
  end
  
  def init_from_params(params)
    self.name = params["name"]
    self.desc = params["desc"]
    self.url  = params["url"]
    self.md5  = Digest::MD5.hexdigest(self.url)
    self
  end
    
  def store(store = @cache)
    store.set "#{md5}_name", self.name
    store.set "#{md5}_desc", self.desc
    store.set "#{md5}_url", self.url
  end
  
end
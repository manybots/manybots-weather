require "manybots-weather/engine"

module ManybotsWeather

  # Yahoo App ID
  mattr_accessor :yahoo_app_id
  @@yahoo_app_id = nil
  
  mattr_accessor :app
  @@app = nil
  
  mattr_accessor :nickname
  @@nickname = nil
  
  def self.setup
    yield self
  end
  
end

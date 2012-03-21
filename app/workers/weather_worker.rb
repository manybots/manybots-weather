# coding: UTF-8

class WeatherWorker
  @queue = :observers
  require 'open-uri'
  
  attr_accessor :location, :weather
  
  def initialize(location_id)
    @location = ManybotsWeather::Location.find(location_id)
    code = @location.code
    unit = @location.unit rescue('c')
    yahoo_api_url = "http://weather.yahooapis.com/forecastjson?w=#{code}&u=#{unit}"
    begin
      weather = JSON.load(open(yahoo_api_url))
    rescue => e
      puts e
    end
    condition =  weather['condition']
    @weather = weather
    self
  end
  
  def self.perform(location_id)
    a = self.new(location_id)
    a.post_to_manybots!
  end
  
  def as_activity
    activity = {}
    activity[:notification] = {
      type: "Weather conditions notification",
      level: "Silent"
    }
    activity[:published] = Time.now.xmlschema
    activity[:title] = "Weather conditions in TARGET: OBJECT"
    activity[:auto_title] = true
    activity[:actor] = {
      displayName: 'Weather Observer',
      objectType: 'application',
      id: ManybotsWeather.app.url,
      url: ManybotsWeather.app.url,
      image: {
        url: ManybotsServer.url + ManybotsWeather.app.app_icon_url
      }
    }
    activity[:icon] = {
      :url => self.weather['condition']['image']
    }
    activity[:verb] = 'report'
    activity[:object] = {
      displayName: "#{self.weather['condition']['text']} (#{self.weather['condition']['temperature']} º#{self.weather['units']['temperature']})",
      objectType: 'weather',
      id: self.weather['url'],
      url: self.weather['url'],
      image: {
        url: self.weather['condition']['image']
      },
      condition: self.weather['condition'].merge(unit: self.weather['units']['temperature'])
    }
    activity[:target] = {
      displayName: self.location.name,
      objectType: 'place',
      id: "#{ManybotsWeather.app.url}/locations/#{self.location.id}",
      url: "#{ManybotsWeather.app.url}/locations/#{self.location.id}",
      position: "#{self.weather['location']['latitude']} #{self.weather['location']['longitude']}",
      address: self.location.name
    }
    activity[:provider] = {
      :displayName => 'Yahoo! Weather',
      :url => "http://weather.yahoo.com",
      :image => {
        :url => self.weather['logo']
      }
    }
    activity[:generator] = {
      :displayName => ManybotsWeather.app.name,
      :url => ManybotsWeather.app.url,
      :image => {
        :url => ManybotsServer.url + ManybotsWeather.app.app_icon_url
      }
    }
    
    
    activity
  end
  
  def post_to_manybots!
    RestClient.post("#{ManybotsServer.url}/notifications.json", 
      {
        :activity => self.as_activity, 
        :client_application_id => ManybotsWeather.app.id,
        :version => '1.0', 
        :auth_token => self.location.user.authentication_token
      }.to_json, 
      :content_type => :json, 
      :accept => :json
    )
  end
  
end

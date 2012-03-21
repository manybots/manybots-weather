# coding: UTF-8

module ManybotsWeather
  class Location < ActiveRecord::Base
    require 'open-uri'
    belongs_to :user
    
    def self.new_from_yahoo(location_string)
      yahoo_api_url = "http://where.yahooapis.com/v1/places.q('#{CGI.escape(location_string.force_encoding('binary'))}')?format=json&appid=#{ManybotsWeather.yahoo_app_id}"
      begin
        data = JSON.load(open(yahoo_api_url))
      rescue => e
        puts e
      end
      if data and data['places'].any? and data['places']['place'].present?
        place = data['places']['place'].first
        location = self.new
        location.code = place['woeid']
        location.name = "#{place['name']}, #{place['country']}"
        location.lat = place['centroid']['latitude']
        location.long = place['centroid']['longitude']
        location
      else
        nil
      end
    end
    
    def lat_long
      "#{self.lat.to_s},#{self.long.to_s}"
    end
    
  end
end

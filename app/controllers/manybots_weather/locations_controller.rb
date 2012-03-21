module ManybotsWeather
  class LocationsController < ApplicationController
    
    before_filter :authenticate_user!
    
    def index
      @locations = Location.where(user_id: current_user.id)
      @schedules = ManybotsServer.queue.get_schedules
    end
    
    def search
      @location = Location.new_from_yahoo(params[:location])
      render layout: false
    end

    def create
      location = Location.new(params[:location])
      location.user_id = current_user.id
      location.save
      
      schedule_name = "import_manybots_weather_location_#{location.id}"
      schedules = ManybotsServer.queue.get_schedules
      
      ManybotsServer.queue.add_schedule schedule_name, {
        :every => '6h',
        :class => "WeatherWorker",
        :queue => "observers",
        :args => location.id,
        :description => "This job will notify of weather conditions every 6 hours for Location ##{location.id}"
      }
      ManybotsServer.queue.enqueue(WeatherWorker, location.id)
      
      redirect_to root_path, :notice => "Now observing weather conditions for #{location.name}"
    end

    def destroy
      location = Location.find(params[:id])
      schedules = ManybotsServer.queue.get_schedules
      schedule_name = "import_manybots_weather_location_#{location.id}"
      if location and location.user_id == current_user.id
        if schedules and schedules.keys.include?(schedule_name)
          ManybotsServer.queue.remove_schedule schedule_name
        end
        location.destroy 
        redirect_to root_path, :notice => "Weather in #{location.name} no longer observed"
      else
        redirect_to root_path, :error => "Nothing was done."
      end
    end
  end
end

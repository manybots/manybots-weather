require 'rails/generators'
require 'rails/generators/base'
require 'rails/generators/migration'


module ManybotsWeather
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      
      source_root File.expand_path("../../templates", __FILE__)
      
      class_option :routes, :desc => "Generate routes", :type => :boolean, :default => true
      class_option :migrations, :desc => "Generate migrations", :type => :boolean, :default => true
      
      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
      
      desc 'Mounts Manybots Weather at "/manybots-weather"'
      def add_manybots_weather_routes
        route 'mount ManybotsWeather::Engine => "/manybots-weather"' if options.routes?
      end
      
      desc "Copies ManybotsWeather migrations"
      def create_model_file
        migration_template "create_manybots_weather_locations.rb", "db/migrate/create_manybots_weather_locations.manybots_weather.rb"
      end
      
      desc "Creates a ManybotsWeather initializer"
      def copy_initializer
        template "manybots-weather.rb", "config/initializers/manybots-weather.rb"
      end
      
      def show_readme
        readme "README" if behavior == :invoke
      end
      
    end
  end
end

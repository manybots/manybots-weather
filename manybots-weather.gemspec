$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "manybots-weather/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "manybots-weather"
  s.version     = ManybotsWeather::VERSION
  s.authors     = ["Alexandre L. Solleiro"]
  s.email       = ["alex@webcracy.org"]
  s.homepage    = "https://www.manybots.com"
  s.summary     = "Be notified of the weather conditions"
  s.description = "Use Yahoo! Weather to import the weather conditions into your Manybots as Notifications. Use this information for yourself, or for other apps."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.2"
  s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end

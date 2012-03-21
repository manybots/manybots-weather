# Manybots Weather Observer

manybots-weather is a Manybots Observer that notifies you of the Weather conditions in any Location, using the Yahoo! Weather API.

Having the weather conditions on your Manybots account enables other apps to use that information and create more useful information, like "you should water the plants today".

## Installation instructions

### Setup the gem

You need the latest version of Manybots Local running on your system. Open your Terminal and `cd` into its' directory.

First, require the gem: edit your `Gemfile`, add the following, and run `bundle install`

```
gem 'manybots-weather', :git => 'git://github.com/manybots/manybots-weather.git'
```

Second, run the manybots-weather install generator (mind the underscore):

```
rails g manybots_weather:install
bundle exec rake db:migrate
```

Now you need to register your Weather Observer with Yahoo! to obtain an API Key.

### Register your Weather Observer with Yahoo!

1. Go to this link: http://developer.yahoo.com/

2. Click on the "My projects" link (you'll need to login or signup using your Yahoo! ID), and then on the "New Project" button.

3. Select a Standard project like shown below:

<img src="https://img.skitch.com/20120321-cfmedu5qpuc3p2rp32nu1hu9pe.png" />

4. Fill out the form and click "Get API KEY"

<img src="https://img.skitch.com/20120321-pj9siqg4inks3ha2ks7jpr78eh.png" />

5. Copy the AppID into `config/initializers/manybots-weather.rb`

```
  config.yahoo_app_id = 'appID'
```  
You don't need to copy the secret.

### Restart and go!

Restart your server and you'll see the Weather Observer in your `/apps` catalogue. Go to the app, select a location and start observing the weather right within Manybots.
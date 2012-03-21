ManybotsWeather::Engine.routes.draw do
  
  match '/locations/search', :to => 'locations#search'

  resources :locations
  
  root :to => 'locations#index'
  
end

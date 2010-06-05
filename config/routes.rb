ActionController::Routing::Routes.draw do |map|
  map.connect '/user/:uid/facebook/events',
              :controller => "home",
              :action => "view"
end

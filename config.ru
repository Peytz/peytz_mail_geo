if ENV['APP_ENV'] != 'production'
  require 'pry'
end

require './app'
run Sinatra::Application

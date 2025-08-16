
dev = ENV['RACK_ENV'] == 'development'

require 'rack/unreloader'

Unreloader = Rack::Unreloader.new(subclasses: %w'Roda', reload: dev) { App }
Unreloader.require('app.rb') { 'App' }

run(dev ? Unreloader : App.freeze.app)
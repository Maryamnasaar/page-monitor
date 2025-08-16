require 'roda'
require 'tilt/sass'


class App < Roda
  plugin :common_logger, $stdout 
  plugin :render, escape: true
  plugin :hash_routes
  plugin :public
  plugin :json

  # load all route files
  require_relative 'routes/pages'
  require_relative 'routes/perf'

  Unreloader.require('routes') {}

  route do |r|
    r.public
    r.hash_routes('')
  end
end
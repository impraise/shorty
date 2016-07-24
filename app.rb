require "cuba"
require "cuba/safe"
require "redic"
require_relative "helpers/environment_helper"
require_relative "lib/redis"

ENV["RACK_ENV"] ||= "development"
ShortyService::Helpers.init_environment(ENV["RACK_ENV"])

Cuba.plugin Cuba::Safe

Cuba.use Rack::Session::Cookie, :secret => ENV["SESSION_SECRET"]

Cuba.use Rack::MethodOverride

Dir["./lib/**/*.rb"].each     { |rb| require rb }
Dir["./models/**/*.rb"].each  { |rb| require rb }
Dir["./validators/**/*.rb"].each  { |rb| require rb }
Dir["./concerns/**/*.rb"].each  { |rb| require rb }
Dir["./routes/**/*.rb"].each  { |rb| require rb }
Dir["./helpers/**/*.rb"].each { |rb| require rb }

Cuba.plugin ShortyService::Helpers

Cuba.define do
  run Routes::ShortyService
end

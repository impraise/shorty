ENV['RACK_ENV'] = 'test'

require 'rack/test'
require File.expand_path('../../api', __FILE__)

def app
  Shorty
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

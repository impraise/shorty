ENV['RACK_ENV'] = 'test'

require 'bundler'

Bundler.require(:default, :test)

require File.expand_path('../../config/environment', __FILE__)
require 'rack/test'
require 'minitest/autorun'

require File.expand_path('../../application', __FILE__)

def app
  Shorty.new
end

class MiniTest::Test
  include Rack::Test::Methods

  DatabaseCleaner.clean_with :truncation
  DatabaseCleaner.strategy = :truncation

  def before_setup
    super
    DatabaseCleaner.clean
    DatabaseCleaner.start
  end
end

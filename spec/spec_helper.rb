ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'dm-transactions'
require "database_cleaner"
require File.expand_path('../../api', __FILE__)

def app
  Shorty
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.order = :random

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

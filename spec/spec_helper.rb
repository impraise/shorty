require 'rspec'
require_relative '../api/shortener.rb'

RSpec.configure do |config|
  config.before :each do
    Redis.new.flushall
  end
end

def app
  Api::Shortener
end

def json
  JSON.parse(last_response.body)
end

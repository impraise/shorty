require 'minitest/spec'
require 'minitest/autorun'
require 'pp'
require 'faker'
require 'rack/test'
require 'mocha/test_unit'
require 'mocha/integration/mini_test/adapter'

ENV["RACK_ENV"]  = 'test'

require File.dirname(__FILE__) + '/../app'

class MiniTest::Spec
  include Rack::Test::Methods
  include Mocha::Integration::MiniTest::Adapter

  def app
    Cuba.app
  end

  after do
    mocha_teardown

    keys = Redis.client.call "KEYS", "*"

    keys.each{ |k| Redis.client.call("DEL", k) }
  end
end

def json_post(path, params = {}, headers = {})
  json_headers = headers.merge("CONTENT_TYPE" => "application/json")

  body = JSON.dump(params)

  post path, body, json_headers
end

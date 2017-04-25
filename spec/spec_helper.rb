require 'rspec'
require 'rspec/json_expectations'
require 'rack/test'
require './app/shorty'

module RSpecMixin
  include Rack::Test::Methods

  def app
    described_class
  end
end

module JsonHelpers
  def json_response
    JSON.parse(last_response.body)
  end
end

RSpec.configure do |config|
  config.expose_dsl_globally = false
  config.include RSpecMixin, type: :request
  config.include JsonHelpers, type: :request

  config.around(:each) do |example|
    InMemoryStorage.instance.reset
    example.run
  end
end

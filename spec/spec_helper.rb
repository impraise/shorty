require 'simplecov'
require 'rspec'
require 'rspec/json_expectations'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

SimpleCov.start

require './app/config'

# = RSpecMixin
# Sinatra-related RSpec mixin
module RSpecMixin
  include Rack::Test::Methods

  def app
    Shorty
  end
end

# = JsonHelpers
# Include this little helper to avoid using JSON.parse all around the specs
module JsonHelpers
  def json_response
    JSON.parse(last_response.body)
  end
end

Shorty.config[:storage_adapter] = 'InMemoryAdapter'

RSpec.configure do |config|
  config.expose_dsl_globally = false
  config.include RSpecMixin, type: :request
  config.include JsonHelpers, type: :request

  config.around(:each) do |example|
    Storage.instance.reset
    example.run
  end
end

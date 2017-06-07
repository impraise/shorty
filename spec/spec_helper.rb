$:.unshift File.expand_path "../..", __FILE__
ENV['RACK_ENV'] = 'test'

require 'config/application'
require 'spec/support/helpers'
require 'spec/support/factories'

include Rack::Test::Methods

RSpec.configure do |config|
  config.include Helpers
  config.include Factories
  config.color = true
  config.formatter = :documentation

  config.mock_with :rspec
  config.expect_with :rspec
  config.raise_errors_for_deprecations!

  config.before(:each) do
    ShortenedUrl.dataset.truncate
  end
end
$:.unshift File.expand_path "../..", __FILE__
require 'config/application'
require "bundler"
require 'spec/support/helpers'

Bundler.require
Bundler.require :test

include Rack::Test::Methods

RSpec.configure do |config|
  config.include Helpers
  config.color = true
  config.formatter = :documentation

  config.mock_with :rspec
  config.expect_with :rspec
  config.raise_errors_for_deprecations!
end
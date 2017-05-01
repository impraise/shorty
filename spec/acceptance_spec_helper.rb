require 'integration_spec_helper'
require 'capybara/rspec'
require_relative '../config/boot'

def app
  Shorty::Api
end

Capybara.configure do |config|
  config.app = app.new
  config.server_port = 9293
end

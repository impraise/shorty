require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"

Bundler.require(*Rails.groups)

module Shorty
  class Application < Rails::Application
    config.api_only = true
    config.middleware.use Rack::Attack
  end
end

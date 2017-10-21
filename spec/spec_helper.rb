# frozen_string_literal: true

# Always run tests in test environment
ENV['RACK_ENV'] = 'test'

require File.expand_path('../../config/application', __FILE__)
require 'rack/test'
require 'support/factory_bot'
require 'database_cleaner'

Dir[Config.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :api
  config.include AppMixin, type: :api

  config.profile_examples = true
  config.order = :random
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    # For some reason Rspec doesn't recognize CustomErrors::* as a specific
    # error class
    expectations.on_potential_false_positives = :nothing
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:suite) do
    ActiveRecord::Base.logger.level = 1 # Info
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

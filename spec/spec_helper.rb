
require 'rack/test'
require_relative '../app'
require 'factory_girl'

ENV['RACK_ENV'] = 'test'

def app
  App
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.before(:all) do
    Mongoid.load!("config/mongoid.yml", :test)
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.after(:all) do
    db = Mongoid.client(:default)
    db.collections.each do |collection|
      collection.drop
    end
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

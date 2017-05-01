
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'app')
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'web')

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

ENV['RACK_ENV'] = 'test'

require 'mongoid'
Mongoid.load!(File.join(File.dirname(__FILE__), '../config/mongoid.yml'))

require 'shorty'
require_relative 'support/shorties'

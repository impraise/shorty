require_relative '../shorty_url/shorty_url'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.order = :random

  config.before(:all) do
    ENV['environment'] = 'test'
  end

  config.after(:each) do
    ShortyUrl.storage.clear!
  end
end

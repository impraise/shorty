ENV['RACK_ENV'] = 'test'

require './shorty'
require 'rspec'
require 'dm-transactions'
require 'database_cleaner'

RSpec.configure do |config|
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.order = :random
  Kernel.srand config.seed

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

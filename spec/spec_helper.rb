require "rspec"
require "factory_girl"
require "active_record"
require "yaml"
require "database_cleaner"
require "rack/test"
require "./lib/app.rb"

# Setup database connection
environment = "test"
configuration = YAML.safe_load(File.open("config/database.yml"))
ActiveRecord::Base.configurations = configuration
ActiveRecord::Base.establish_connection(configuration[environment])

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Rack::Test::Methods

  config.before(:suite) do
    FactoryGirl.find_definitions
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

require "rspec"
require "factory_girl"
require "active_record"
require "yaml"
require "./lib/app.rb"

# Setup database connection
environment = "test"
configuration = YAML.safe_load(File.open("config/database.yml"))
ActiveRecord::Base.configurations = configuration
ActiveRecord::Base.establish_connection(configuration[environment])

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    FactoryGirl.find_definitions
  end
end

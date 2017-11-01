require 'sequel'

ENV["RACK_ENV"] = 'test'

require_relative '../shorty_app'

# Database cleaner
RSpec.configure do |config|
  config.after(:all) do
    [:shorties, :collisions].each{|x| Sequel::Model.db.from(x).truncate}
  end
end

# Constants
VALID_URL = 'http://example.com'
INVALID_URL = 'testing.shorty'

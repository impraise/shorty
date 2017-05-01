require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.shared_context 'MongoDB' do
  before :each do
    DatabaseCleaner[:mongoid].start
    Support::Shorties.existing_shorty.save
  end

  after :each do
    DatabaseCleaner[:mongoid].clean
  end
end

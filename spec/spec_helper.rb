require 'rspec'

# Dir['../api/*.rb'].each {|file| require file }
require_relative '../api/example.rb'

RSpec.configure do |config|
  # config.include RSpec::Rails::RequestExampleGroup, :type => :request, :example_group => {
  #   :file_path => /spec\/api/
  # }
end

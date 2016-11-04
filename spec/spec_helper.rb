ENV['RACK_ENV'] = 'test'

require './shorty'
require 'rspec'

RSpec.configure do |config|
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.order = :random
  Kernel.srand config.seed
end

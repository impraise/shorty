# Check https://github.com/jhollinger/otr-activerecord
require './config/environment.rb'

# Connect to Database
OTR::ActiveRecord.configure_from_file!(
  Config.root.join('config', 'database.yml')
)

# Load application
[
  %w(config initializers *.rb),
  %w(config initializers ** *.rb),
  %w(lib *.rb),
  %w(lib ** *.rb),
  %w(app serializers *.rb),
  %w(app api ** *.rb),
  %w(app api *.rb),
  %w(app models ** *.rb)
].each do |pattern|
  Dir.glob(Config.root.join(*pattern)).each { |file| require file }
end

require 'ostruct'
require 'pathname'

# Load environment settings
Config = OpenStruct.new
Config.env = ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : :development
Config.root = Pathname.new(File.expand_path('../..', __FILE__))

# Load dependencies
require 'bundler'
Bundler.require(:default, Config.env)

# Check https://github.com/bkeepers/dotenv
require 'dotenv'
Dotenv.load(
  Config.root.join('.env.local'),
  Config.root.join(".env.#{Config.env}"),
  Config.root.join('.env')
)

Config.include_backtrace = true

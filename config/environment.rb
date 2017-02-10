require 'rubygems'
require 'bundler'
Bundler.require

require 'dotenv/load'

Dir.glob(File.expand_path('../initializers/**/*.rb', __FILE__)).each { |f| require f }
Dir.glob(File.expand_path('../../app/**/*.rb', __FILE__)).each { |file| require file }

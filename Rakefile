require 'rake'
require 'bundler'
Bundler.setup
require 'grape-raketasks'
require 'grape-raketasks/tasks'

desc 'load the environment.'
task :environment do
  require File.expand_path('shorty_url/api/api', File.dirname(__FILE__))
end

require "sinatra/activerecord/rake"

namespace :db do
  task :load_config do
    require "./application"
  end
end

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.fail_on_error = false
  end
  task :default => :spec
rescue LoadError
  # no rspec available
end

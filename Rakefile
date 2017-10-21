# For some reason otr-activerecord tasks
# can't find the db connection,
# hence the require below
require_relative 'config/application'

require 'bundler/setup'
load 'tasks/otr-activerecord.rake'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
rescue LoadError
end

task :environment do
  require_relative 'config/application'
end

desc 'List available routes'
task routes: :environment do
  rows = []
  API::V1::Base.routes.each do |route|
    rows << [route.version, route.request_method,
             route.path, route.description]
  end
  puts Terminal::Table.new(
    headings: %w(Version Method Path Description),
    rows: rows
  )
end

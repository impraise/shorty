
namespace :test do
  ENV["RACK_ENV"] = 'test'

  desc "Runs all tests in test/validators"
  task :validators do
    Dir["test/validators/*.rb"].each{ |file| load file }
  end

  desc "Runs all tests in test/concerns"
  task :concerns do
    Dir["test/concerns/*.rb"].each{ |file| load file }
  end

  desc "Runs all tests in test/models"
  task :models do
    Dir["test/models/*.rb"].each{ |file| load file }
  end

  desc "Runs all tests in test/routes}"
  task :routes do
    Dir["test/routes/*.rb"].each{ |file| load file }
  end

  desc "Runs all tests in test/{validators, concerns, routes}"
  task :all => [:validators, :concerns, :models, :routes]
end

task :test => "test:all"

def load_files(dir)
  Dir[dir].each { |file| load file }
end

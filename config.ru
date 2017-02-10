require "./lib/app.rb"
require "sinatra/activerecord"
current_dir = Dir.pwd
Dir["#{current_dir}/lib/models/*.rb"].each { |file| require file }
run Sinatra::Application

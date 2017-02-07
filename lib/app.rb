require "sinatra"

current_dir = Dir.pwd
Dir["#{current_dir}/models/*.rb"].each { |file| require file }

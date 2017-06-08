require 'sinatra'
require 'sinatra/activerecord'
set :database, {adapter: "sqlite3", database: "shorty.sqlite3"}


require_relative 'lib/init'
require_relative 'app/controllers/init'

require_relative 'routes'

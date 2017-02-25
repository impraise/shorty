require 'byebug'
require 'sinatra'
require 'sinatra/base'
require "sinatra/reloader"
require 'sinatra/namespace'
require 'sinatra/contrib/all'
require 'sinatra/json'

require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-migrations'

ENV['RACK_ENV'] ||= 'development'

class Shorty < Sinatra::Application

  configure :development do
    DataMapper::Logger.new(STDOUT, :debug)
    DataMapper::setup(:default, "sqlite3:db/#{ENV['RACK_ENV']}.sqlite")

    register Sinatra::Reloader
  end

  configure :test do
    DataMapper.setup(:default, 'sqlite3::memory:')
  end

end

Dir["#{Dir.pwd}/lib/*.rb"].each { |file| require file }
Dir["#{Dir.pwd}/models/*.rb"].each { |file| require file }

DataMapper.finalize.auto_upgrade!

require_relative 'routes'

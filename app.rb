#!/usr/bin/env ruby

require 'data_mapper'
require 'sinatra/base'

class ShortyApp < Sinatra::Base
  configure do
    disable :sessions
  end

  configure :development do
    DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite3:db/development.db')
    DataMapper::Logger.new(STDOUT, :debug)
  end

  configure :test do
    DataMapper.setup(:default, 'sqlite3::memory:')
  end
end

require_relative 'models'

DataMapper.finalize
DataMapper.auto_upgrade!

require_relative 'routes'

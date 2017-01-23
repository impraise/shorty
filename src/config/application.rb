#!/usr/bin/env ruby
require "rubygems"

File.expand_path('../Gemfile', __dir__)
require 'bundler/setup'

Bundler.require(:default) # load all the default gems
Bundler.require(Sinatra::Base.environment)

require './app/shorten_exception'
require './app/shortcode_generator'
require './app/short_url'
require './app/short_url_service'
require './app/routes'

DataMapper.finalize

class ImpraiseShortyApp < Sinatra::Base
  configure :development do
    DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/datastore/shorty.development.sqlite3")
    DataMapper.finalize.auto_upgrade!
    DataMapper::Logger.new(STDOUT, :debug)
  end

  configure :test do
    DataMapper.setup(:default, 'sqlite3::memory:')
  end
  use Routes
end

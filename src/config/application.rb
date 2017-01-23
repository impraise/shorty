#!/usr/bin/env ruby
require "rubygems"

File.expand_path('../Gemfile', __dir__)
require 'bundler/setup'

Bundler.require(:default) # load all the default gems
Bundler.require(Sinatra::Base.environment)


class ImpraiseShortyApp < Sinatra::Base
  configure :development do
    DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/datastore/shorty.development.sqlite3")
    DataMapper.finalize.auto_upgrade!
    DataMapper::Logger.new(STDOUT, :debug)
  end

  configure :test do
    DataMapper.setup(:default, 'sqlite3::memory:')
  end
end

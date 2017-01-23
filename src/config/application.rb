#!/usr/bin/env ruby
require "rubygems"

File.expand_path('../Gemfile', __dir__)
require 'bundler/setup'

Bundler.require(:default) # load all the default gems
Bundler.require(Sinatra::Base.environment)


class ImpraiseShortyApp < Sinatra::Base
end

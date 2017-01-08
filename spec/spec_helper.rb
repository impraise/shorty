require 'simplecov'
SimpleCov.start

require 'rack/test'
require_relative '../shortener'

ENV['MONGODB_URI'] = 'mongodb://127.0.0.1:27017/shortener_db_test'

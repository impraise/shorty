$:.unshift File.expand_path "..", __FILE__
ENV['RACK_ENV'] = 'production'

require 'config/application'

run Shorty::API 
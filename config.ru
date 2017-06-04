$:.unshift File.expand_path "..", __FILE__

require 'config/application'

run Shorty::API 
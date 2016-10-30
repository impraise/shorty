require 'grape'
require_relative 'shorty_url/shorty_url'
require_relative 'shorty_url/api/api'

ENV['environment'] = 'development'
run Rack::Cascade.new [ShortyUrl::API]

require 'grape'
require_relative 'shorty_url/shorty_url'
require_relative 'shorty_url/api/api'

run Rack::Cascade.new [ShortyUrl::API]

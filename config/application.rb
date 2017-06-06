require "config/environments/#{ENV['RACK_ENV']}"

require "lib/models/shortened_url"
require "lib/errors/shorty_errors"
require "lib/services/create_shortened_url_service"
require "lib/api/post_shorten"
require "lib/api/api"
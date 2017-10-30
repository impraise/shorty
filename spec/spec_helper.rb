require 'sequel'
ENVIRONMENT = 'test'
require_relative '../database_setup'
require_relative '../shorty/shorty'
require_relative '../shorty/collision'

require_relative '../shorty_app'
require 'rack/test'

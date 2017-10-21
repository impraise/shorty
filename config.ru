require './config/application'
require 'grape_logging'

use OTR::ActiveRecord::ConnectionManagement
run Rack::Cascade.new([API::Base])

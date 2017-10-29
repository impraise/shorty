ENVIRONMENT = 'development'
short_code_collisions = Hash.new

require_relative 'database_setup'
require_relative 'shorty/collision'
require_relative 'shorty/shorty'

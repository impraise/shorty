require 'mongoid'

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'app')
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'web')

ENV['RACK_ENV'] ||= 'development'
require 'pry' if ENV['RACK_ENV'] == 'development'

Mongoid.load!(File.join(File.dirname(__FILE__), 'mongoid.yml'))

require 'shorty'
require 'web'

System = Shorty.dependencies(
  eagerly_initialize: ENV['RACK_ENV'] != 'development'
)

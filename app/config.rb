require './app/shorty'
require './app/storages/storage'
require './app/models/shortcode'
require './app/controllers/shorty_controller'

Shorty.config[:env] = ENV.fetch('RACK_ENV', 'development')
Shorty.config[:storage_adapter] = ENV.fetch('SHORTY_STORAGE_ADAPTER', 'InMemoryAdapter')

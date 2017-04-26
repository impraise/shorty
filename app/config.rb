require './app/shorty'
require './app/storages/storage'
require './app/models/shortcode'
require './app/controllers/shorty_controller'

Shorty.config[:env] = ENV.fetch('SHORTY_ENV', 'dev')
Shorty.config[:storage_adapter] = ENV.fetch('SHORTY_STORAGE_ADAPTER', 'InMemoryAdapter')

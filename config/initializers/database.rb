db_pool = ENV['DATABASE_POOL'] || 5
DB = Sequel.connect(adapter: ENV['DATABASE_ADAPTER'], user: ENV['DATABASE_USERNAME'], password: ENV['DATABASE_PASSWORD'],
  host: ENV['DATABASE_HOST'], database: ENV['DATABASE_NAME'], max_connections: db_pool)

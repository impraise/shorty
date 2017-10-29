require 'sqlite3'
require 'sequel'

DB = Sequel.sqlite("database-#{ENVIRONMENT}.sqlite3")

if ENVIRONMENT == 'test'
  DB[:shorties].truncate
  DB[:collisions].truncate
end

DB.create_table? :shorties do
  primary_key :id
  String :url
  String :shortcode
  Timestamp :start_date
  Timestamp :last_seen_date
  Integer :redirect_count
end

DB.create_table? :collisions do
  String :shortcode
  Integer :shorty_id
end

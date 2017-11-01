require 'sqlite3'
require 'sequel'

DB = Sequel.sqlite("database-#{ENV['RACK_ENV']}.sqlite3")

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

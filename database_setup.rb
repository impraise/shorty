require 'sqlite3'
require 'sequel'

DB = Sequel.sqlite("database-#{ENVIRONMENT}.sqlite3")

DB.create_table? :shorties do
  primary_key :id
  String :url
  String :shortcode
  Timestamp :start_date
  Timestamp :last_seen_date
  Integer :redirect_count
end

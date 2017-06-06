require "bundler"
Bundler.require
Bundler.require :production

DB = Sequel.connect "sqlite://db/shorty.sqlite3"

require "lib/api/shorten"
require "lib/api/api"
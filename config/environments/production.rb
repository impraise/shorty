require "bundler"

Bundler.require
Bundler.require :production

DB = Sequel.connect "sqlite://db/shorty.production.sqlite3"

require "bundler"

Bundler.require
Bundler.require :test

DB = Sequel.connect "sqlite://db/shorty.test.sqlite3"

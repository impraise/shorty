namespace :db do
  task :connect do
    require File.expand_path('../../../config/environment.rb',  __FILE__)
    Sequel.extension :migration
  end

  task :environment do
    require 'dotenv'
    Dotenv.load(".env.#{ENV['RACK_ENV']}", '.env')
  end

  desc "Creates the database from DATABASE_NAME environment variable"
  task create: :environment do
    %x( createdb -E UTF8 -T template0 #{ENV['DATABASE_NAME']} )
    puts "Database #{ENV['DATABASE_NAME']} created successfully"
  end

  desc "Drops the database from DATABASE_URL environment variable"
  task drop: :environment do
    %x( dropdb #{ENV['DATABASE_NAME']} )
    puts "Database #{ENV['DATABASE_NAME']} dropped successfully"
  end

  desc "Migrate the database (options: VERSION environment variable)"
  task migrate: :connect do
    target = ENV['VERSION'].to_i unless ENV['VERSION'].nil?
    Sequel::Migrator.run(DB, "db/migrate", target: target)
    puts "Database migrated successfully"
    DB.disconnect
  end

  desc "Rolls the schema back to the previous version"
  task rollback: :connect do
    current = DB[:schema_info].first
    target = current[:version] - 1 if current[:version] > 0
    Sequel::Migrator.run(DB, "db/migrate", target: target)
    puts "Database rolled back successfully"
    DB.disconnect
  end

  desc "Drop the database, create and run all migrations"
  task setup: [:drop, :create, :migrate]

  desc "Retrieves the current schema version number"
  task version: :connect do
    current = DB[:schema_info].first
    puts "The current schema version number is: #{current[:version]}"
    DB.disconnect
  end
end

source 'https://rubygems.org'

ruby '2.3.1'

gem 'rails', '~> 5.0.0'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'active_model_serializers', '~> 0.10.2'
gem 'rack-cors'

group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.4'
end

group :development do
  gem 'better_errors'
  gem 'guard-rspec',    '~> 4.7',     require: false
  gem 'guard-rubocop',  '~> 1.2',     require: false
  gem 'rubocop',        '~> 0.40.0',  require: false
  gem 'listen',         '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'database_cleaner',   '~> 1.5'
  gem 'timecop',            '~> 0.8.1'
  gem 'factory_girl_rails', '~> 4.7'
  gem 'faker',              '~> 1.6'
end

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "sinatra"
gem "json"
gem "redis"

group :development do
  gem 'pry-byebug'
end

group :test do
  gem "rspec"
  gem "rack-test", require: 'rack/test'
end

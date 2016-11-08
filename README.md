# Julien's Shorty Implementation

A Shorty implementation in Ruby on Rails 5.0 in API mode with MongoDB as backend and RSpec for test.

## Installation

* Make sure MongoDB is installed and running. I've tested on lastest stable but should be fine with earlier versions.
* `git clone git@github.com:hartator/shorty.git`
* `cd shorty && bundle install`

## Run Tests
`bundle exec rspec spec`

## Files where the logic is located

The `Url` model holds the logic responsible of storing and validating shortcode data:

* Model -> https://github.com/hartator/shorty/blob/master/app/models/url.rb
* Tests -> https://github.com/hartator/shorty/blob/master/spec/models/url_spec.rb

The `UrlController` holds the API endpoints:

* Model -> https://github.com/hartator/shorty/blob/master/app/controllers/url_controller.rb
* Tests -> https://github.com/hartator/shorty/blob/master/spec/controllers/url_controller_spec.rb

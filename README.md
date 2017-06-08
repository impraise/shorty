Shorty
================
An URL shortener made in Ruby and Sinatra

## Language
To install Ruby I recommend follow the steps on [RVM](https://rvm.io/)

## Running the code
If you don't have bundler installed :
```shell
gem install bundler

bundle install

rackup -p 4567
```

## Running the tests
I decided to use RSpec for the tests, to run it, all you have to do is type:
```shell
rspec
```

## Solution Explanation
When I am not using Rails, I like to create one class for each controller action, by doing that way we can have a smaller and simpler controller and also, it's good for maintainability and easier to test.
On the routes file, I simply handled the logic related to request and response, leaving all the logic to the service classes and controllers (when the logic wasn't complicated)

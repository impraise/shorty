# Shorty Service

This is a simple proof of concept of a micro service to shorten URLs.

It exposes an [API](#api-documentation) with endpoints for [shortening a URL](#post-shorten), for [using a shortened URL](#get-shortcode) and for [listing some stats about a shortened URL](#get-shortcodestats).

## Prerequisites

You'll need to meet the following in order to run the code in this repository:

* A Ruby environment (tested on 2.2.2 and 2.3.1, but anything > 2.0 should work)
* A Redis server available

It is recommended to use a gemset to isolate gems used in this PoC.

### Gems

It requires three gems for runtime:

* `cuba`
* `redic`
* `scrivener`

And two extra ones if you want to run tests

* `rack-test`
* `mocha`

Gems dependencies are listed in `.gems` and `.gems-test` files. These are to be used with the [dep](https://rubygems.org/gems/dep) gem. If you want to use `dep`, first [get the code](#clone-the-repository), then run the following within the cloned directory:

```
gem install dep
dep install && dep -f .gems-test install
```

Otherwise, you can just `gem install` them manually.

## Running the code

### Clone the repository

```
git clone https://github.com/kandalf/shorty && cd shorty
```

If you're using some Ruby manager compatible with the `.ruby-version` config file, such as RVM, copy the sample file:

```
cp ruby-version.sample .ruby-version && cd .
```

Now you can [install necessary gems](#gems) so they get isolated in the right gemset.

### Setup Environments

The environment setup is done through shell files defining environment variables. The repository provides the `env.sh.sample` file to be used as a template for this.

The service requires only one environment variable defined:

* `REDIS_URL` The URL for the redis server and database number

Configure your access to redis for each environment, by copying the `env.sh.sample` file for each environment, for example:

```Bash
cp env.sh.sample development.env.sh
cp env.sh.sample test.env.sh
```

Then edit these files and modify the Redis URL for your environment.

*NOTE*: The test database will get shredded on each test run, make sure you choose a proper number for it to avoid any existent data loss.

The default database number for Redis is `0`, so if you're already using Redis and never specified the database number, make sure you specify a different number for these environments.


### Run the tests

The code is tested using `minitest` form the Ruby core library and `mocha` for mocks and stubs.
Make sure you have [installed the necessary gems](#gems), then you can run all tests:

The `Rakefile` provides a generic rake task, for convenience, to run all the tests

```
rake test
```

If you want to run tests separately, the `Rakefile` provides several tasks for that:

```
[kandalf@funkymonkey shorty]$ rake -T
rake test             # Run all tests
rake test:all         # Runs all tests in test/{validators, concerns, models, routes}
rake test:concerns    # Runs all tests in test/concerns
rake test:models      # Runs all tests in test/models
rake test:routes      # Runs all tests in test/routes
rake test:validators  # Runs all tests in test/validators
```

Or you can run individual tests with the ruby interpreter, for example:

```
ruby test/routes/shorten_url_test.rb
```

### Run the service

This is a Rack application, it comes with a `config.ru` file, to run the service run the `rackup` command:

```
[kandalf@funkymonkey shorty]$ rackup
[2016-07-24 19:14:36] INFO  WEBrick 1.3.1
[2016-07-24 19:14:36] INFO  ruby 2.2.2 (2015-04-13) [x86_64-darwin14]
[2016-07-24 19:14:36] INFO  WEBrick::HTTPServer#start: pid=4221 port=9292
```

At this point you'll have the service listening at `http://localhost:9292`

You can use curl to interact with it, for example:

```
curl -v -XPOST -H"Content-type: application/json" http://localhost:9292/shorten -d "{\"url\":\"http://threefunkymonkeys.com\",\"shortcode\":\"1214sR\"}"
```

Make sure you read the [API Documentation](#api-documentation) the README.md file for this.

-------------------------------------------------------------------------

## API Documentation

**All responses must be encoded in JSON and have the appropriate Content-Type header**


### POST /shorten

```
POST /shorten
Content-Type: "application/json"

{
  "url": "http://example.com",
  "shortcode": "example"
}
```

Attribute | Description
--------- | -----------
**url**   | url to shorten
shortcode | preferential shortcode

##### Returns:

```
201 Created
Content-Type: "application/json"

{
  "shortcode": :shortcode
}
```

A random shortcode is generated if none is requested, the generated short code has exactly 6 alpahnumeric characters and passes the following regexp: ```^[0-9a-zA-Z_]{6}$```.

##### Errors:

Error | Description
----- | ------------
400   | ```url``` is not present
409   | The the desired shortcode is already in use. **Shortcodes are case-sensitive**.
422   | The shortcode fails to meet the following regexp: ```^[0-9a-zA-Z_]{4,}$```.


### GET /:shortcode

```
GET /:shortcode
Content-Type: "application/json"
```

Attribute      | Description
-------------- | -----------
**shortcode**  | url encoded shortcode

##### Returns

**302** response with the location header pointing to the shortened URL

```
HTTP/1.1 302 Found
Location: http://www.example.com
```

##### Errors

Error | Description
----- | ------------
404   | The ```shortcode``` cannot be found in the system

### GET /:shortcode/stats

```
GET /:code
Content-Type: "application/json"
```

Attribute      | Description
-------------- | -----------
**shortcode**  | url encoded shortcode

##### Returns

```
200 OK
Content-Type: "application/json"

{
  "startDate": "2012-04-23T18:25:43.511Z",
  "lastSeenDate": "2012-04-23T18:25:43.511Z",
  "redirectCount": 1
}
```

Attribute         | Description
--------------    | -----------
**startDate**     | date when the url was encoded, conformant to [ISO8601](http://en.wikipedia.org/wiki/ISO_8601)
**redirectCount** | number of times the endpoint ```GET /shortcode``` was called
lastSeenDate      | date of the last time the a redirect was issued, not present if ```redirectCount == 0```

##### Errors

Error | Description
----- | ------------
404   | The ```shortcode``` cannot be found in the system



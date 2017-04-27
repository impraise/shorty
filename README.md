Shorty
================

[![Code Climate](https://codeclimate.com/github/focusshifter/shorty/badges/gpa.svg)](https://codeclimate.com/github/focusshifter/shorty) [![Test Coverage](https://codeclimate.com/github/focusshifter/shorty/badges/coverage.svg)](https://codeclimate.com/github/focusshifter/shorty/coverage)

Another variation of Shorty The URL Shortener. This version uses Sinatra and (optionally) Redis.

### Installation

Install RVM and Ruby.
```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable
rvm install ruby
gem install bundler
```

Install Git and clone the repository.
```
sudo apt-get -y install git
git clone https://github.com/focusshifter/shorty
cd shorty
bundle install
```

### Install Redis (optional)

This step is required if you want to use Redis storage adapter (and have any persistence at all).
```
sudo apt-get -y install redis-server
sudo service redis-server start
```

### Run application

```
rackup -p <PORT_NUMBER>
```

### Run specs

```
rspec
```

### Check for code smells manually

```
rubocop
reek
```

### Check coverage

Check `./coverage` for the coverage report after running `rspec`.

### Using different storage adapters

You can select the adapter by setting the `SHORTY_STORAGE_ADAPTER` environment variable. Default adapter provides simple in-memory hash-based storage, allowed values are `InMemoryAdapter` and `RedisAdapter`.

```
export SHORTY_STORAGE_ADAPTER=RedisAdapter
export SHORTY_STORAGE_ADAPTER=InMemoryAdapter
```

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
409   | The desired shortcode is already in use. Shortcodes are case-sensitive.
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
GET /:shortcode/stats
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

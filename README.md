Shorty Challenge
================

A solution of the URL shortner challenge.

It is written in Ruby using Sinatra and DataMapper.

-------------------------------------------------------------------------

## Getting started

These instructions will help you to get Shortly up. They assume you use Ubuntu 14.04.

### Prerequisites

Make sure you have Ruby (>=2.0), Bundler, and SQlite3 installed with development header files:

```
apt-get install -y ruby2.0 ruby2.0-dev bundler libsqlite3-dev
```

Switch the default Ruby version to 2.0:

```
update-alternatives \
        --install /usr/bin/ruby ruby /usr/bin/ruby2.0 400 \
        --slave /usr/bin/rake   rake /usr/bin/rake2.0     \
        --slave /usr/bin/ri     ri   /usr/bin/ri2.0       \
        --slave /usr/bin/rdoc   rdoc /usr/bin/rdoc2.0     \
        --slave /usr/bin/gem    gem  /usr/bin/gem2.0      \
        --slave /usr/bin/irb    irb  /usr/bin/irb2.0
```

### Dependencies

Use Bundler to install Shorty's dependencies:

```
bundle install
```

### Testing

To run tests use:

```
ruby test.rb
```

It will create a coverage report, which you can open by `open coverage/index.html`.

### Taking off

To run Shortly use:

```
puma
```

### Docker

The project contains Dockerfile which you can use to build a container on top of
a fresh copy of Ubuntu 14.04:

```
docker build -t shorty .

# To run
docker run --rm -i -t -p 9292:9292 shorty

# To test
docker run --rm -i -t shorty
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

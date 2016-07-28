Shorty API
================

This is a Ruby on Rails API that allows you to create short URLs. Setup instructions as well as endpoint definitions follow.


## Deployment Documentation

This assumes the following have been installed:

* Ubuntu Machine
* Ruby > 2.2.3
* Git
* Bundler

In order to keep this as simple as possible as per the instructions, I stuck with sqlite3 and webrick.

I also made a decision to return a 422 with multiple errors on POST /shorten as this seemed more user friendly in the event multiple errors were present.

1. Clone the repo: `git clone git@github.com:boobooninja/shorty.git`
2. Change directory to shorty.
3. Run `bundle install`
4. DB setup: `rake db:create db:migrate`
5. Start webserver: `bundle exec rails s`

## Testing Documentation

```
$ cd to_shorty_directory
$ bundle install
$ RAILS_ENV=test bundle exec rake db:create db:migrate
$ bundle exec rspec
```

-------------------------------------------------------------------------

## API Documentation


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
422   | ```url``` is not present
422   | The the desired shortcode is already in use. **Shortcodes are case-sensitive**.
422   | The shortcode fails to meet the following regexp: ```^[0-9a-zA-Z_]{6}$```.


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

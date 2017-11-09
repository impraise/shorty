Shorty Challenge
================

This is a Rails API handling requests.
Json responses are built with Jbuilder.
API Documentation is put together with the Apipie gem.
httpie used as HTTP client for making requests to the API.

-------------------------------------------------------------------------
## Installation

run ./shorty.sh from within the project's directory and bundle install after cloning the repository.

## API Documentation

Available at ```http://localhost:3000/apipie```

## Tests

run the ```bundle exec rspec``` command from within the project's directory for running the full test suite.

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
**last_seen_date**    | date of the last time the a redirect was issued, not present if ```redirectCount == 0```
**redirect_count** | number of times the endpoint ```GET /shortcode``` was called
**start_date**     | date when the url was encoded, conformant to [ISO8601](http://en.wikipedia.org/wiki/ISO_8601)

##### Errors

Error | Description
----- | ------------
404   | The ```shortcode``` cannot be found in the system

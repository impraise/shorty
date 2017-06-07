Shorty Challenge
================

## System Dependencies

  * Ruby 2.3.1
  * Sqlite3

## Project Dependencies

  * Grape
  * Sequel

## Running the project

### With Docker

  * Clone the repository: `git clone git@github.com:pedrocalgaro/shorty.git`
  * Create the container: `docker build -t shorty .`
  * Run the container: `docker run --name shorty -d -p 9292:9292 shorty`
  * Running tests: `docker exec -it shorty rspec`

Ps. Since I am using Sqlite as a datastore, there is no need for creating a docker-compose here.

### Without Docker

  * Clone the repository: `git clone git@github.com:pedrocalgaro/shorty.git`
  * Run bundle: `bundle`
  * Run migrations: 
    * Prod: `sequel -m db/migrations/ sqlite://db/shorty.production.sqlite3`
    * Test: `sequel -m db/migrations/ sqlite://db/shorty.test.sqlite3`
  * Start the server: `rackup`
  * Running tests: `rspec`

## Usage example

Creating a shortcode:
```
curl -i -H "Content-Type: application/json" \
        -X POST http://localhost:9292/shorten \
        -d '{"url":"http://google.com", "shortcode": "google"}'
```

Get Shortcode
```
curl -X GET -i http://localhost:9292/google
```

Get Shortcode Status
```
curl -X GET -i http://localhost:9292/google/stats
```


---------------------
The trendy modern question for developer inteviews seems to be, "how to create an url shortner". Not wanting to fall too far from the cool kids, we have a challenge for you!

## The Challenge

The challenge, if you choose to accept it, is to create a micro service to shorten urls, in the style that TinyURL and bit.ly made popular.

## Rules

1. The service must expose HTTP endpoints according to the definition below.
2. The service must be self contained, you can use any language and technology you like, but it must be possible to set it up from a fresh install of Ubuntu Server 14.04, by following the steps you write in the README.
3. It must be well tested, it must also be possible to run the entire test suit with a single command from the directory of your repository.
4. The service must be versioned using git and submitted by making a Pull Request against this repository, git history **should** be meaningful.
5. You don't have to use a datastore, you can have all data in memory, but we'd be more impressed if you do use one.

## Tips

* Less is more, small is beautiful, you know the drill — stick to the requirements.
* Use the right tool for the job, rails is highly discouraged.
* Don't try to make the microservice play well with others, the system is all yours.
* No need to take care of domains, that's for a reverse proxy to handle.
* Unit tests > Integration tests, but be careful with untested parts of the system.

**Good Luck!** — not that you need any ;)

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



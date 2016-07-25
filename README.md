Shorty Challenge
================

Shorty is a micro service to shorten urls, in the style that TinyURL and bit.ly made popular.

## Requirements

 * Ruby 2.3.1
 * Postgres database

## Getting Started

Clone the repository, install gems and setup the database by running:

```sh
git clone git@github.com:evandrodutra/shorty.git
cd shorty
bundle install
bundle exec rake db:setup
bundle exec rake db:migrate
bundle exec puma -p 3000
```

## Development

#### Tests

To run tests exec:

```sh
bundle exec rspec
```

#### Guard

You can use guard to automatically run tests and rubocop:

```sh
bundle exec guard
```

## Using Docker

You can avoid all the setup above and run the project using Docker. To get Docker set up and running please read the docs: [Docker install](https://www.docker.com/products/overview).


#### Build docker container:

```sh
docker-compose build
```

#### Initialize database and run migrations:

```sh
docker-compose run app rake db:setup db:migrate
```

#### Start container and services on [http://localhost:3000](http://localhost:3000):

```sh
docker-compose up
```

#### To run tests:

```sh
docker-compose run app bundle exec rspec
```

## API Usage

#### POST /shorten
```sh
curl -X POST -i -H "Content-Type: application/json" -d '{ "url": "http://www.bbc.com/", "shortcode": "bbcnews" }' "http://localhost:3000/shorten"
```

#### GET /:shortcode

```sh
curl -X GET -i -H "Content-Type: application/json" "http://localhost:3000/bbcnews"
```

#### GET /:shortcode/stats

```sh
curl -X GET -i -H "Content-Type: application/json" "http://localhost:3000/bbcnews/stats"
```

## API Documentation

**All responses must be encoded in JSON and have the appropriate Content-Type header**


### POST /shorten

```sh
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

```sh
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

```sh
GET /:shortcode
Content-Type: "application/json"
```

Attribute      | Description
-------------- | -----------
**shortcode**  | url encoded shortcode

##### Returns

**302** response with the location header pointing to the shortened URL

```sh
HTTP/1.1 302 Found
Location: http://www.example.com
```

##### Errors

Error | Description
----- | ------------
404   | The ```shortcode``` cannot be found in the system

### GET /:shortcode/stats

```sh
GET /:shortcode/stats
Content-Type: "application/json"
```

Attribute      | Description
-------------- | -----------
**shortcode**  | url encoded shortcode

##### Returns

```sh
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
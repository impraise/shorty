Shorty
================

Shorty is a simple URL shortening API using [Sinatra](http://www.sinatrarb.com/).

## Installing docker compose

This application uses [docker compose](https://docs.docker.com/compose/) to keep setup simple.
You can find the installation instructions [here](https://docs.docker.com/compose/install/).

How to install docker on a fresh install of Ubuntu Server 14.04:

```
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual

curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -
sudo add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"

sudo apt-get update
sudo apt-get -y install docker-engine
```

How to install docker compose:

```
curl -L https://github.com/docker/compose/releases/download/1.11.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

## Running the application

Start by cloning the application:

```
  git clone git@github.com:JSFernandes/shorty.git
  cd shorty
```

You can run the application with the following command:

```
docker-compose up
```

## Testing

This application uses [RSpec](http://rspec.info/) for testing.
You can run the test suite with the following command:

```
docker-compose run web bundle exec rspec
```

## Code style

This application uses [Rubocop](https://github.com/bbatsov/rubocop) to enforce the code style.
You can run it with the following command:

```
docker-compose run web bundle exec rubocop
```

## Known caveats

* URLs are not validatedd on POST to `/shorten`
* Ruby 2.4.0 launches deprecation warnings due to some of the included gems
* `docker-compose.yml` and `config/database.yml` should be using environment variables in order to be used in production

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

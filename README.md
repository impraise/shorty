Shorty
================

Simple URL shortener microservice powered by Sinatra and PostgreSQL.

## Install on Ubuntu 14.04

First install git:
```bash
sudo apt-get install --assume-yes git
```

First clone the repository:
```bash
git clone https://github.com/tegon/shorty.git
```

Install `rvm` and `ruby 2.4.0`:
```bash
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash
source ~/.rvm/scripts/rvm
rvm install ruby-2.4.0
```

Install `postgresql`:
```bash
sudo apt-get update
sudo apt-get install --assume-yes postgresql postgresql-contrib
```

Crete a user and set a password:
```bash
sudo -u postgres createuser --superuser $USER
sudo -u postgres psql
\password $USER # Change $USER to current user (e.g. ubuntu)
```

Update the `.env` file with the new credentials:
```bash
vim .env
DATABASE_USERNAME=ubuntu
DATABASE_PASSWORD=password
```

Install required packages to build our gems:
```bash
sudo apt-get install --assume-yes libpq-dev build-essential
```

Inside the application directory, install the dependencies running:
```bash
cd shorty
gem install bundler
bundle install
```

Create the database and run the migrations:
```bash
rake db:create db:migrate
```

The first time you run the tests, you need to setup the database:
```bash
RACK_ENV=test rake db:setup
```

You can run the tests using:
```bash
rake test
```

Start the application running:
```bash
puma config.ru
```

You can access the application now at: [http://localhost:9292](http://localhost:9292)

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

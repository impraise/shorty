# Shorty

This project is a basic URL shortener built on top of Elixir, using the
Phoenix Framework and Postgres to store all the information.

**tl;dr**
```
$ docker-compose up dev (or prod)
$ docker-compose run tests
```

## Configuration
Elixir and Erlang can be installed using the following:
```
$ brew install elixir
```

The database used is Postgres and the following environment variables need
to be configured:
```
PG_DATABASE (defaults to `shorty_dev`)
PG_HOSTNAME (defaults to `localhost`)
PG_PORT (defaults to 5432)
PG_USERNAME (defaults to `postgres`)
PG_PASSWORD (optional)
```

## Running
With Elixir installed and Postgres running, we can install the
dependencies and run the initial migrations using the follow command:
```
$ mix deps.get
$ mix ecto.setup
```
There's no need to run `mix compile` after installing the dependencies
because it will be called automatically when running the application (if
there are changes in the codebase as well):
```
$ mix phoenix.server
```

A Dockerfile is also available and to run the development version (`dev`)
we can use the following:
```
$ docker-compose build dev && docker-compose up dev
```
To run in a production environment, switch `dev` to `prod` and there will
be changes in the log levels and other related stuff within the Phoenix
Framework.

For both Docker version and the local (using `mix phoenix.server`), the
web server will be available at [`localhost:4000`](http://localhost:4000).
For `prod`, the PORT number changes to `5000`. You can have them running
at the same time because it uses different databases.

## Tests
Running tests in this project is pretty straightforward. You can run them
locally or using Docker, just like the application itself.

```
$ mix test
```

```
$ docker-compose build tests && docker-compose run tests
```

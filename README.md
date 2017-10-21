Shorty
================
A URL shortener

## Setup on a Linux box

### TL;DR
Using setup.sh for an easier life.
Change the mode of the script to executable using: `chmod +x setup.sh` and run `./setup.sh`

### Dependencies

#### Ruby

Shorty uses Ruby version 2.3.1 and it has a `.ruby-version` file which is used by [rbenv](https://github.com/rbenv/rbenv).

#### SQLite3

Shorty uses SQLite3 to store data. To install it use:
`sudo apt-get install sqlite3`

### Install the Gems
run `bundle install`

### Start the server
The webserver used is Puma, by default puma runs on port `9292` to run puma on a different port use: `puma -p $PORT_NUMBER`

## Development

To kick start your development environment, shorty comes with a tmux session starter script (`shorty-dev.sh`) but before you can use it, you need to make sure you have `tmux` installed.

Check if `tmux` is installed using: `which tmux`.

To install `tmux` use: `sudo apt-get install tmux`

Change the mode of the script to executable using: `chmod +x shorty-dev.sh`.
From within the root directory of this repository run `./shorty-dev.sh` to start you preset `tmux` session.

## Testing

Shorty uses `rspec` for tests. To run all tests use the command `rspec` from within the root directory of this repository.
On Shorty, `rspec` is configured by default to run in a test environment, so you don't have to worry about adding extra env variables.

## Documentation

Shorty is documented using [yard](https://yardoc.org/). If you used the preset `tmux` session, `yard` server should be running on port 8808 unless you have another process using the same port.

If you want to manually run it use `yard server`.

## Gems

List of gems used by Shorty is listed below:
1. Task and Process management
1.1. foreman
1.2. rake
2. Web server
2.1. puma
3. API Framework
3.1. grape
3.2. grape-swagger
3.3. grape_logging
4. Database, ORM, and Serializers
4.1. active_model_serializers
4.2. activerecord
4.3. otr-activerecord
4.4. sqlite3
5. Infra
5.1. dotenv
6. Testing
6.1. database_cleaner
6.2. rack-test
6.3. rspec
6.4. shoulda-matchers
6.5. factory_bot
6.6. faker
7. Documentation
7.1. yard
8. Misc
8.1. awesome_print
8.2. hirb
8.3. pry
8.4. pry-byebug
8.5. pry-coolline
8.6. pry-doc
8.7. pry-stack_explorer

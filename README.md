Shorty
================

[![Code Climate](https://codeclimate.com/github/focusshifter/shorty/badges/gpa.svg)](https://codeclimate.com/github/focusshifter/shorty) [![Test Coverage](https://codeclimate.com/github/focusshifter/shorty/badges/coverage.svg)](https://codeclimate.com/github/focusshifter/shorty/coverage)

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

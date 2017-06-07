FROM ruby:2.3.1

# general dependencies
RUN apt-get update && apt-get install -qq -y build-essential

# for sqlite
RUN apt-get install -y sqlite3

# Setting up Workdir
ENV APP_HOME /shorty  
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Caching Gemfile
ADD Gemfile $APP_HOME  
ADD Gemfile.lock $APP_HOME
RUN bundle install

# Copying project to container
ADD . $APP_HOME

# Migrations
RUN sequel -m db/migrations/ sqlite://db/shorty.production.sqlite3
RUN sequel -m db/migrations/ sqlite://db/shorty.test.sqlite3

EXPOSE 9292

CMD ["rackup"]
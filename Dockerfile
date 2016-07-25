FROM ruby:2.3.1-slim
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN bundle config --global frozen 1

COPY Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install --jobs 20 --retry 5

ENV app /usr/src/shorty
RUN mkdir -p $app
WORKDIR $app
COPY . $app

EXPOSE 3000

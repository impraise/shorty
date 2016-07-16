FROM ruby:2.3.1-slim

MAINTAINER Dmitry Zuev <mail@dzuev.ru>

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev libxml2-dev libxslt1-dev nodejs

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

COPY . /usr/src/app

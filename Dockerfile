FROM ruby:2.4.0
RUN apt-get update -qq && apt-get install
RUN mkdir /shorty
WORKDIR /shorty
ADD Gemfile /shorty/Gemfile
ADD Gemfile.lock /shorty/Gemfile.lock
RUN bundle install
ADD . /shorty

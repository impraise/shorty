FROM ruby:2.2.4-onbuild
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev sqlite

RUN mkdir -p /shorty
WORKDIR /shorty

RUN bundle config --global frozen 1

COPY Gemfile Gemfile.lock ./

COPY . ./

RUN bundle install
RUN bundle exec rake db:create db:migrate RAILS_ENV=production

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-e", "production"]


FROM elixir:1.4.2
ENV REFRESHED_AT 2017-04-27

RUN /usr/local/bin/mix local.hex --force && \
    /usr/local/bin/mix local.rebar --force

ENV APP_HOME /shorty/
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD mix.* $APP_HOME
ADD config/  $APP_HOME/config/
ADD test/test_helper.exs $APP_HOME/test/test_helper.exs

RUN mix deps.get
RUN mix compile

ADD . $APP_HOME

FROM ubuntu:14.04

RUN apt-get update -y && \
    apt-get install -y ruby2.0 ruby2.0-dev bundler libsqlite3-dev && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives \
        --install /usr/bin/ruby ruby /usr/bin/ruby2.0 400 \
        --slave   /usr/bin/rake rake /usr/bin/rake2.0     \
        --slave   /usr/bin/ri   ri   /usr/bin/ri2.0       \
        --slave   /usr/bin/rdoc rdoc /usr/bin/rdoc2.0     \
        --slave   /usr/bin/gem  gem  /usr/bin/gem2.0      \
        --slave   /usr/bin/irb  irb  /usr/bin/irb2.0

ADD . /src
WORKDIR /src

RUN bundle install

EXPOSE 9292

CMD ["/usr/bin/env", "puma"]

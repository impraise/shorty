# https://hub.docker.com/r/xqdocker/ubuntu-ruby-2.3/
FROM xqdocker/ubuntu-for-ruby:1.1.3

#Install Ruby 2.3

RUN apt-get update \
    && apt-get -y install \
        sqlite3 libsqlite3-dev software-properties-common \
    && add-apt-repository -y ppa:brightbox/ruby-ng \
    && apt-get update \
    && apt-get -y install \
        ruby2.3 \
        ruby2.3-dev \
    && rm -rf /var/lib/apt/lists/*


RUN echo `ruby -v`

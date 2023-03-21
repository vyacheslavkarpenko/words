FROM ruby:3.1.2-alpine

# Install postgres libs and dependencies, plus python-ldap depdency
RUN apk add --no-cache --update-cache postgresql-libs\
        postgresql-dev postgresql-client\
        libffi-dev openldap-dev unixodbc-dev git

RUN apk add py-pip \
    build-base \
    && pip install awscli --upgrade --user

RUN apk add --no-cache ruby-dev \
  ruby ruby-io-console ruby-irb \
  ruby-json ruby-etc ruby-bigdecimal ruby-rdoc \
  libffi-dev zlib-dev
RUN ruby --version

RUN apk update \
    && apk add build-base \
     tzdata

# Gem setup. Install bundler
RUN echo 'gem: --no-document --no-rdoc --no-ri' > ~/.gemrc
RUN gem update --system
RUN gem --version
RUN gem install bundler -v 2.3.23
RUN bundler --version


RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install
ADD . /app




FROM ruby:2.4.1-alpine
MAINTAINER Ricardo Roman <r.rmn92@gmail.com>
RUN mkdir /usr/src/app /usr/src/app/tmp && apk update && apk add curl-dev ruby-dev build-base \
    zlib-dev libxml2-dev libxslt-dev tzdata yaml-dev \
    ruby ruby-io-console ruby-json yaml nodejs
WORKDIR /usr/src/app
COPY ./Gemfile /usr/src/app
RUN bundle install
EXPOSE 4567
COPY . /usr/src/app

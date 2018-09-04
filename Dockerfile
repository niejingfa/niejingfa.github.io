FROM ruby:2.3
MAINTAINER guxiaobai <sikuan.gu@gmail.com>

RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.org

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD Gemfile /usr/src/app/
ADD Gemfile.lock /usr/src/app/
RUN bundle install

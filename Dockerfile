# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Rails app lives here
WORKDIR /app


# Throw-away build stage to reduce size of final image
FROM base as build_dev_image

# Install packages needed to build gems and node modules
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential curl git pkg-config

#------------------------------------------------------------
# IMMAGINE DI SVILUPPO
FROM build_dev_image as development_image

ARG default_editor
RUN apt-get install -y nano gpg gpg-agent git-lfs git ssh
#questo serve per editare le credentials
ENV EDITOR='nano' \
    BUNDLE_PATH="/bundle"
# helper per webpacker
RUN touch /.yarnrc && chmod 777  /.yarnrc
RUN mkdir /.cache && chmod 777 /.cache
RUN adduser --system -D --uid 1000  -h /home/nobody  --shell /bin/bash rails rails


RUN mkdir /bundle && chmod -R ugo+rwt /bundle
VOLUME /bundle

##
# Installiamo:
# bundle-audit  : gemma per controllo di sicurezza https://github.com/rubysec/bundler-audit
# bummr         : gemma per upgrade automatizzato delle gemme con singoli commit per gemma
RUN gem install bundle-audit bummr

RUN mkdir -p /home/nobody && chmod 777 /home/nobody
ENV HOME="/home/nobody"


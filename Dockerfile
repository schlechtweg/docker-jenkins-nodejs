FROM jenkins:2.7.4-alpine

MAINTAINER David Schlechtweg "david.schlechtweg@me.com"

USER root

# repo contains docker
RUN echo "http://dl-6.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories; 

# needed deps
RUN apk add --update --no-cache ca-certificates \
    openssl \
    bash \
    nodejs \
    make \
    gcc \
    g++ \
    git \
    curl \
    openssh \
    docker \
    py-pip \
    python \
    build-base && \
    update-ca-certificates && \
    npm install -g node-gyp  && \
    npm install -g gulp 

# install docker compose
RUN pip install docker-compose

# create dir for npm cache (run npm config set cache /var/npm/cache)
RUN mkdir /var/npm && chown jenkins:jenkins /var/npm

USER jenkins

# adding initial jenkins plugins
RUN /usr/local/bin/install-plugins.sh git nodejs docker-build-step

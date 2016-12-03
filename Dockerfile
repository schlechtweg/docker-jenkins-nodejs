FROM ubuntu:14.04

# based on docker image from https://github.com/killercentury/docker-jenkins-dind
MAINTAINER David Schlechtweg "david.schlechtweg@me.com"

# global versions
ENV DOCKER_COMPOSE_VERSION 1.9.0
ENV NODEJS_VERSION 7.2.0
ENV DOCKER_MACHINE_VERSION 0.8.2

# basic packages
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables \
    python \
    build-essential \
    git


#
# docker
#

# install docker core
RUN curl -sSL https://get.docker.com/ | sh

# install the wrapper script from https://raw.githubusercontent.com/docker/docker/master/hack/dind.
ADD ./dind /usr/local/bin/dind
RUN chmod +x /usr/local/bin/dind

ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# docker compose
RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# docker machine
RUN curl -L https://github.com/docker/machine/releases/download/v${DOCKER_MACHINE_VERSION}/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine
RUN chmod +x /usr/local/bin/docker-machine

# Define additional metadata for our image.
VOLUME /var/lib/docker


#
# jenkins
#

# install jenkins
RUN wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
RUN sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
RUN apt-get update && apt-get install -y zip supervisor jenkins && rm -rf /var/lib/apt/lists/*
RUN usermod -a -G docker jenkins
ENV JENKINS_HOME /var/lib/jenkins
VOLUME /var/lib/jenkins
# adding initial jenkins plugins
#RUN /usr/local/bin/install-plugins.sh git nodejs docker-build-step


#
# nodejs
#

# create dir for npm cache (run npm config set cache /var/npm/cache)
RUN mkdir /var/npm && chown jenkins:docker /var/npm

# nodejs
RUN mkdir /nodejs && curl http://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.gz | tar xvzf - -C /nodejs --strip-components=1
ENV PATH $PATH:/nodejs/bin
# needed global npm deps
RUN npm install -g node-gyp  && \
    npm install -g gulp 

#
# process manager
#

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080

CMD ["/usr/bin/supervisord"]


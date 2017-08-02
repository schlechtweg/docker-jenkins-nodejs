## Jenkins CI Server with Docker in Docker Support

This is a [Jenkins CI](http://jenkins-ci.org/) server with docker in docker support (dind), espacially for building [NodeJS](http://nodejs.org/) applications and composing docker images. The main image is based on docker image from https://github.com/killercentury/docker-jenkins-dind.

Preinstalled build dependencies:
- [NodeJS](https://nodejs.org/) v8.1.4
- [NPM](https://www.npmjs.com) v3.10.9
- [Gulp CLI](http://gulpjs.com) v3.9.1
- [Grunt CLI](https://gruntjs.com) v1.0.1
- [Bower](https://bower.io) v1.8.0
- [Sass](http://sass-lang.com) v3.5.1
- [Node Gyp](https://github.com/nodejs/node-gyp) v3.4.0
- [NightwatchJS](http://nightwatchjs.org) v0.9.9
- [Docker](https://docker.com/) v17.06.0
- [Docker Compose](https://docs.docker.com/compose/) v1.14.0
- [Docker Machine](https://docs.docker.com/machine/) v0.12.2
- [Jenkins CI](http://jenkins-ci.org/) v2.34
- [Oracle Java JDK](https://www.oracle.com/de/java/) v1.8.0
- [Sonarqube](https://www.sonarqube.org) v6.4


## Running this container

You can run this container by:

```
docker run -d \
  -p 8080:8080 \
  -p 9000:9000 \
  --privileged \
  -e DOCKER_DAEMON_ARGS="-H tcp://127.0.0.1:4243 -H unix:///var/run/docker.sock" \
  --restart=always \
  -v /my/jenkins/home:/var/lib/jenkins \
  -v /my/sonarqube/home/conf:/var/lib/sonarqube-6.4/conf \
  -v /my/sonarqube/home/data:/var/lib/sonarqube-6.4/data \
  --name myJenkinsContainer \
  schlechtweg/jenkins-nodejs
```

 * runs the container;
 * maps the host port 8080 (jenkins) to the container port 8080;
 * maps the host port 9000 (sonarqube) to the container port 9000;
 * mount jenkins volume
 * mount sonarqube data and config dir volume
 * to connect to an docker deamon
 * sets an "always" restart policy;
  * adds your docker host to the container /etc/hosts file so that Jenkins can access the Docker API
 * names the image jenkins.

## Hints

 * prevent NPM EACCES errors cause missing permissions on mounted volumes (e.g. on nodejs git dependencies)
  * the container contains a folder ```/var/npm/``` (owner and group is jenkins).
  * you can set the npm cache directory to this folder by adding an jenkins build command ```npm config set cache /var/npm/cache``` 
 * how-to persist my jenkins config?
  * add jenkins home (/var/lib/jenkins) volume on docker statup command.
  * All settings will be stores there
 * how-to ssh public key auth outside docker container?
  * create an ```.ssh```directory (permission 700) in your jenkins home directory and copy your private ssh key (permission 644)
 

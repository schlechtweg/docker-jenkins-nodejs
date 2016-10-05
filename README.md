## Jenkins CI Server

This is a [Jenkins CI](http://jenkins-ci.org/) server, espacially for building [NodeJS](http://nodejs.org/) applications and composing docker images.

Preinstalled build dependencies:
- [NodeJS](https://nodejs.org/) v6.2.0
- [NPM](https://www.npmjs.com) v3.8.9
- [Gulp CLI](http://gulpjs.com) v3.9.1
- [Node Gyp](https://github.com/nodejs/node-gyp) v3.4.0
- [Docker](https://docker.com/) v1.11.2
- [Docker Compose](https://docs.docker.com/compose/) v1.8.1
- [Jenkins CI](http://jenkins-ci.org/) v2.7.4


## Running this container

You can run this container by:

```
docker run -d \
  -p 8080:8080 \
  --restart=always \
  -v /my/jenkins/home:/var/jenkins_home \
  --name jenkins \
  schlechtweg/jenkins-nodejs
```

 * runs the container;
 * maps the host port 8080 to the container port 8080;
 * sets an "always" restart policy;
 * maps the host folder /my/jenkins/home into the container as the Jenkins home folder; (optional)
 * names the image jenkins.

## Hints

 * prevent NPM EACCES errors cause missing permissions on mounted volumes (e.g. on nodejs git dependencies)
 ** the container contains a folder ```/var/npm/``` (owner and group is jenkins).
 ** you can set the npm cache directory to this folder by adding an jenkins build command ```npm config set cache /var/npm/cache``` 
 * how-tp persist my jenkins config?
 ** add jenkins home volume on docker statup command.
 ** All settings will be stores there
 * how-to ssh public key auth outside docker container?
 ** create an ```.ssh```directory (permission 700) in your jenkins home directory and copy your private ssh key (permission 644)

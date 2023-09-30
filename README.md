# Jenkins on docker infrastructure

The following will setup jenkins and jenkins agents on ubuntu host with docker. (it can work on any host with docker but the scripts are tested on ubuntu).

## Build The Custom Jenkins Docker Image

``` shell
docker build -t myjenkins-blueocean:2.414.2 .
docker network create jenkins
```

## Build The Custom Jenkins Docker Image

``` shell
docker run --name jenkins-blueocean -d --restart=always --network jenkins -p 8080:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home -v jenkins-docker-certs:/certs/client:ro -e DOCKER_HOST=tcp://docker:2376 -e DOCKER_CERT_PATH=/certs/client -e DOCKER_TLS_VERIFY=1 myjenkins-blueocean:2.414.2
sleep 10
echo "---- jenkins admin password ----"
docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
echo "--------------------------------"
docker run --name alpine-socat -d --restart=always --network jenkins -p 127.0.0.1:2376:2375 -v /var/run/docker.sock:/var/run/docker.sock alpine/socat tcp-listen:2375,fork,reuseaddr unix-connect:/var/run/docker.sock
docker inspect alpine-socat | grep IPAddress
```

## Stop jenkins infra.

``` shell
docker rm -f jenkins-blueocean
docker rm -f alpine-socat
```

## Clean network and volumes.

``` shell
docker network rm jenkins
docker volume rm jenkins-data
docker volume rm jenkins-docker-certs
```

# Setup Docker Cloud

Go to settings and setup a Docker cloud

use temaplte with the agent image

``` shell
jenkins/agent:alpine-jdk11
```

set the lable to "docker-alpine-jdk11"

# Build Docker-on-Docker

After setting up Docker Cloud, in docker template settings mount to docker socket.

``` shell
type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock
```

## Using docker agent without installed docker client

- In docker template settings change user to "root"
- In job pipeline add step to install docker

``` shell
apk add --update --no-cache docker
```



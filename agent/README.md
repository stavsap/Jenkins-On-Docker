# Agents

Docker images with Jenkins agent can be found on [docker hub](https://hub.docker.com/r/jenkins/agent).

They are base imagees that can work in Docker cloud managed by jenkins. additional tools etc can be install on them for specific build use cases.

## Agent based on alpine JDK 11

This is a clean jenkins agent with jenkins client and jdk 11

``` shell
docker build -t myjenkinsagent-jdk11  .
docker tag myjenkinsagent-jdk11 localhost:5000/myjenkinsagent-jdk11
docker push localhost:5000/myjenkinsagent-jdk11
```

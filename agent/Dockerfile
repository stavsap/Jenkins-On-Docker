FROM jenkins/agent:alpine-jdk11 
USER root
RUN apk update
RUN apk add --update --no-cache docker
RUN apk add docker-compose
USER jenkins

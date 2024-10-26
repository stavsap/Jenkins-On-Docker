FROM jenkins/agent:alpine-jdk21
USER root
RUN apk update
RUN apk add --update --no-cache docker
RUN apk add docker-compose
USER jenkins

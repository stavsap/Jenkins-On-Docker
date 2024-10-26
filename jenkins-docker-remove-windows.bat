@echo off

docker rm -f jenkins
docker rm -f alpine-socat
docker rm -f jenkins-docker-registry

timeout 15 /nobreak

docker network rm jenkins
docker volume rm jenkins-data
docker volume rm jenkins-docker-certs
docker volume rm jenkins-registry-data

echo Full Clean Complete

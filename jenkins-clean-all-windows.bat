@echo off

docker rm -f jenkins-blueocean
docker rm -f alpine-socat
docker rm -f jenkins-docker-registry

sleep 15

docker network rm jenkins
docker volume rm jenkins-data
docker volume rm jenkins-docker-certs
docker volume rm jenkins-registry-data

echo "All Complete"

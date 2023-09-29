# jenkins-docker

``` shell
docker build -t myjenkins-blueocean:2.414.2 .
docker network create jenkins
```

``` shell
docker run --name jenkins-blueocean -d --restart=always --network jenkins -p 8080:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home -v jenkins-docker-certs:/certs/client:ro -e DOCKER_HOST=tcp://docker:2376 -e DOCKER_CERT_PATH=/certs/client -e DOCKER_TLS_VERIFY=1 myjenkins-blueocean:2.414.2
sleep 10
echo "---- jenkins admin password ----"
docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword
echo "--------------------------------"
docker run --name alpine-socat -d --restart=always --network jenkins -p 127.0.0.1:2376:2375 -v /var/run/docker.sock:/var/run/docker.sock alpine/socat tcp-listen:2375,fork,reuseaddr unix-connect:/var/run/docker.sock
docker inspect alpine-socat | grep IPAddress
```

``` shell
docker rm -f jenkins-blueocean
docker rm -f alpine-socat
```

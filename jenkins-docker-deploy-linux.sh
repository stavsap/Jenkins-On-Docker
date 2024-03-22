git clone https://github.com/stavsap/jenkins-docker.git
cd jenkins-docker

docker build -t myjenkins-blueocean:2.414.2 .
docker network create jenkins

echo "Running myjenkins-blueocean:2.414.2..."
docker run --name jenkins-blueocean -d --restart=always --network jenkins -p 8080:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home -v jenkins-docker-certs:/certs/client:ro -e DOCKER_HOST=tcp://docker:2376 -e DOCKER_CERT_PATH=/certs/client -e DOCKER_TLS_VERIFY=1 myjenkins-blueocean:2.414.2

echo "Running alpine/socat..."
docker run --name alpine-socat -d --restart=always --network jenkins -p 127.0.0.1:2376:2375 -v /var/run/docker.sock:/var/run/docker.sock alpine/socat tcp-listen:2375,fork,reuseaddr unix-connect:/var/run/docker.sock

echo "Running registry:latest..."
docker run -it -d --name jenkins-docker-registry -p 5000:5000 -v jenkins-registry-data:/var/lib/registry --restart always registry:latest

echo "Waiting for 20 seconds..."
sleep 20

docker build -t myjenkinsagent-jdk11 ./agent/
docker tag myjenkinsagent-jdk11 localhost:5000/myjenkinsagent-jdk11
docker push localhost:5000/myjenkinsagent-jdk11

PASS=$(docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword)

echo ""
echo "All complete, got to http://localhost:8080 for jenkins UI, init password is: $PASS"

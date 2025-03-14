git clone https://github.com/stavsap/Jenkins-On-Docker.git
cd Jenkins-On-Docker

docker build -t myjenkins:1 .
docker network create jenkins

echo "Running myjenkins:1..."
docker run --name jenkins -d --restart=always --network jenkins -p 8080:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home -v jenkins-docker-certs:/certs/client:ro -e DOCKER_HOST=tcp://docker:2376 -e DOCKER_CERT_PATH=/certs/client -e DOCKER_TLS_VERIFY=1 myjenkins:1

echo "Running alpine/socat..."
docker run --name alpine-socat -d --restart=always --network jenkins -p 127.0.0.1:2376:2375 -v /var/run/docker.sock:/var/run/docker.sock alpine/socat tcp-listen:2375,fork,reuseaddr unix-connect:/var/run/docker.sock

echo "Running registry:latest..."
docker run -it -d --name jenkins-docker-registry -p 5000:5000 -v jenkins-registry-data:/var/lib/registry --restart always registry:latest

echo "Waiting for 15 seconds..."
sleep 15

echo "Building docker jenkins agent..."
docker build -t myjenkinsagent-jdk21 ./agent/
docker tag myjenkinsagent-jdk21 localhost:5000/myjenkinsagent-jdk21
docker push localhost:5000/myjenkinsagent-jdk21

echo --------------------------------
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
echo --------------------------------
cd ..
rm -rf Jenkins-On-Docker
echo ""
echo "All complete, got to http://localhost:8080"

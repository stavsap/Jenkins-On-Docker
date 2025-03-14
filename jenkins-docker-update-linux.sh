git clone https://github.com/stavsap/Jenkins-On-Docker.git
cd Jenkins-On-Docker

docker rm -f jenkins

sleep 5

docker rmi myjenkins:1

docker build -t myjenkins:1 .
docker network create jenkins

echo "Running myjenkins:1..."
docker run --name jenkins -d --restart=always --network jenkins -p 8080:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home -v jenkins-docker-certs:/certs/client:ro -e DOCKER_HOST=tcp://docker:2376 -e DOCKER_CERT_PATH=/certs/client -e DOCKER_TLS_VERIFY=1 myjenkins:1

cd ..
rm -rf Jenkins-On-Docker
echo ""
echo "All complete, got to http://localhost:8080"

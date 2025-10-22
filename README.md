# Build images
docker build -t jenkins-docker:lts-jdk21 .

# Run container
docker run -d \
  --name jenkins-docker \
  -p 8080:8080 -p 50000:50000 \
  -v $HOME/docker/jenkins/jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins-docker:lts-jdk21

# Open Jenkins
http://localhost:8080/

initial password: /var/jenkins_home/secrets/initialAdminPassword

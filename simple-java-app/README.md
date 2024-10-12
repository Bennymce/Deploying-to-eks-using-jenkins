# deploying-EKS-App-using-jenkins
Deploying an EKS app from Jenkins pipeline 
DEPLOY AN APP TO EKS EKS CLUSTER FROM JENKINS PIPELINE


For this task, i'm running jenkins as a docker container using 
docker pull jenkins/jenkins:2.414.3-jdk17

I already have an empty running EKS cluster 

run jenkins as a root user to have root priviledges using docker exec -u 0 -it
containerid or name> /bin/bash

https://github.com/Bennymce/Deploying-to-eks-using-jenkins.git


docker run -d \
  -p 8080:8080 -p 50000:50000 \
  -v /home/ubuntu/Deploying-to-eks-using-jenkins/simple-java-app:/var/jenkins_home/workspace/jenkins-app \
  -v /var/jenkins_home \
  --name jenkins jenkins/jenkins:lts



docker run -d \
  --name jenkins-docker \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /home/myusername/Deploying-to-eks-using-jenkins/simple-java-app:/var/jenkins_home/workspace/jenkins-app \
  jenkins/jenkins:lts

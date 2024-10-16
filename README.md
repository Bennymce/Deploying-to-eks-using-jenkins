# deploying-EKS-App-using-jenkins
Deploying an EKS app from Jenkins pipeline 
DEPLOY AN APP TO EKS EKS CLUSTER FROM JENKINS PIPELINE


For this task, i'm running jenkins as a docker container using 
docker pull jenkins/jenkins:2.414.3-jdk17

I already have an empty running EKS cluster 

run jenkins as a root user to have root priviledges using docker exec -u 0 -it
containerid or name> /bin/bash
# Deploying-to-eks-using-jenkins




ssh -i jenkins-server.pem ubuntu@18.188.23.85
sh 'sudo docker build -t my-java-app:test ./simple-java-app'


eksctl create cluster --name newapp-cluster --region us-east-2 --nodes 2

To update my kube config file 
aws eks --region us-east-2 update-kubeconfig --name newapp-cluster


scp /path/to/your/local/file username@jenkins-server:/var/lib/jenkins/workspace/my-job/
cp /home/ubuntu/Deploying-to-eks-using-jenkins/kubeconfig /var/lib/jenkins/workspace/my-job/
ls -l /var/lib/jenkins/workspace/



mkdir -p /var/lib/jenkins/workspace/my-job/


Set permissions
Ensure that the jenkins user has permission to access and modify this directory:
sudo chown -R jenkins:jenkins /var/lib/jenkins/workspace/my-job


Verify the copy
Check if the kubeconfig file is now in the my-job directory:
ls -l /var/lib/jenkins/workspace/my-job/

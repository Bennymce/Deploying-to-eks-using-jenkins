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


eksctl create cluster --name benny-java-cluster --region us-east-2 --nodes 2

To update my kube config file 




kubectl create namespace <namespace-name>

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




        which aws-iam-authenticator
/usr/local/bin/aws-iam-authenticator


export KUBECONFIG=~/.kube/kubecconfig-java
kubectl get nodes
export KUBECONFIG=$KUBECONFIG:~/.kube/kubecconfig-java

https://oidc.eks.us-east-2.amazonaws.com/id/16852A7F964C0526BB485F76C211CC41


kubectl annotate serviceaccount jenkins-service-account \
  -n jenkins \
  eks.amazonaws.com/role-arn=arn:aws:iam::010438494949:role/jenkins-ecr-access-role


secret
 kubectl get ServiceAccount jenkins-service-account -n jenkins

 to generate a secret/token name jenkins-service-account-token or create secret using a yaml file 
 kubectl create secret generic jenkins-service-account-token --from-literal=token=$(openssl rand -hex 32) --namespace jenkins

 bind secret to the serviceaccount
kubectl patch serviceaccount jenkins-service-account -n jenkins -p '{"secrets": [{"name": "jenkins-service-account-token"}]}'

retrieve token 
kubectl get secret jenkins-service-account-token -n jenkins -o jsonpath='{.data.token}' | base64 --decode
kubectl get secret $(kubectl get serviceaccount jenkins-service-account -n jenkins -o jsonpath='{.secrets[0].name}') -n jenkins -o jsonpath='{.data.token}' | base64 --decode
 then use the decoded token value in the token part for the kubeconfig file 

verify secret is attcahed to servcie account 
kubectl get serviceaccount jenkins-service-account -n jenkins -o yaml







apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: certificate-authority-data: 
    server:   https://100E584D809B03C2057ADE0FC1AD625E.gr7.us-east-2.eks.amazonaws.com
  name: arn:aws:eks:us-east-2:010438494949:cluster/java-cluster
contexts:
- context:
    cluster: arn:aws:eks:us-east-2:010438494949:cluster/benny-java-cluster
    user: arn:aws:eks:us-east-2:010438494949:cluster/benny-java-cluster
  name: arn:aws:eks:us-east-2:010438494949:cluster/benny-java-cluster
current-context: arn:aws:eks:us-east-2:010438494949:cluster/benny-java-cluster
users:
- name: arn:aws:eks:us-east-2:010438494949:cluster/benny-java-cluster
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - --region
      - us-east-2
      - eks
      - get-token
      - --cluster-name
      - benny-java-cluster
      - --output
      - json
      command: aws
      env: null
      interactiveMode: IfAvailable
      provideClusterInfo: false
      
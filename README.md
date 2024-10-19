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








      


      withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
    // some block
}


withCredentials([usernamePassword(credentialsId: 'aws-credentials', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {

withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {     

       aws eks describe-cluster --name benny-java-cluster --query "cluster.identity.oidc.issuer" --output text
    aws iam create-policy --policy-name JenkinsEKSRolePolicy --policy-document file://eks-policy.json
aws iam create-role --role-name JenkinsEKSRole --assume-role-policy-document file://trust-policy.json
aws iam attach-role-policy --role-name JenkinsEKSRole --policy-arn arn:aws:iam::010438494949:policy/JenkinsEKSRolePolicy


 stage('Kubeconfig') {
            steps {
                script {
                    // Use the withKubeConfig block to load the kubeconfig secret
                    withKubeConfig(
                        clusterName: "${CLUSTER_NAME}",
                        contextName: 'arn:aws:eks:us-east-2:010438494949:cluster/benny-java-cluster', // Provide a valid context name if needed
                        credentialsId: 'kubeconfig-secret', // Reference the Jenkins secret for kubeconfig
                        namespace: '', // Specify namespace if required, else keep it blank
                        serverUrl: "${SERVER_URL}", // EKS API server URL
                        restrictKubeConfigAccess: false // Allow access without restriction
                    ) {
                        // Run kubectl commands to interact with the cluster
                        sh 'kubectl get nodes'
                    }
                }
            }
        }
    }

    

    jenkins-role
    jenkins-service-account

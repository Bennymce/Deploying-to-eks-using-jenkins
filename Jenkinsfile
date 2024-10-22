pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-2'
        ECR_REPO = '010438494949.dkr.ecr.us-east-2.amazonaws.com/jenkins-repo'
        IMAGE_TAG = "${env.BRANCH_NAME}-${env.BUILD_ID}" // Use branch name and build ID for image tag
        IMAGE_NAME = "${ECR_REPO}:${IMAGE_TAG}" // Full image name with tag
        CLUSTER_NAME = 'deploy-cluster' // EKS cluster name
    }

    stages {
        stage('Login to AWS ECR') {
            steps {
                script {
                    // Login to ECR using IAM role
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    sh "docker build -t ${IMAGE_NAME} ." // Build Docker image with tag
                }
            }
        }

        stage('Tag and Push Docker Image to ECR') {
            steps {
                script {
                    // Tag the Docker image
                    sh "docker tag ${IMAGE_NAME} ${ECR_REPO}:${IMAGE_TAG}"
                    // Push the Docker image to ECR
                    sh "docker push ${ECR_REPO}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to Kubernetes') { // Deploy the application to Kubernetes
            steps {
                script {
                    // Uncomment the following block if you need to specify AWS credentials explicitly.
                    // Otherwise, if using an IAM role on the instance, this can be omitted.
                    //withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        
                    // Update kubeconfig for the EKS cluster
                    sh "aws eks update-kubeconfig --name ${CLUSTER_NAME} --region ${AWS_REGION}"

                    // Apply the Kubernetes deployment configuration
                    sh 'kubectl apply -f java-app-deployment.yaml --namespace=jenkins' 
                    
                    // Check the status of the pods
                    sh 'kubectl get pods --namespace=jenkins'
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Clean the workspace after the build
        }
    }
}

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
    }


        stage('Deploy to Kubernetes') { // Corrected stage definition
            steps {
                script {
                    //withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) { 
                        sh 'aws eks update-kubeconfig --name deploy-cluster --region us-east-2'
                        // Apply the deployment and service YAMLs
                        sh 'kubectl apply -f java-app-deployment.yaml --namespace jenkins' 
                        // Ensure that deployment.yaml exists in the Jenkins workspace
                    }
                }
            }
        }
     


    post {
        always {
            cleanWs() // Clean the workspace after the build
        }
    }


pipeline {
    agent any
    tools {
        maven 'app-maven'
        dockerTool 'app-docker'
    }

    environment {
        AWS_REGION = 'us-east-2'
        ECR_REPO = '010438494949.dkr.ecr.us-east-2.amazonaws.com/jenkins-repo'
        IMAGE_TAG = "${env.BRANCH_NAME}-${env.BUILD_ID}" // Use branch name and build ID for image tag
        IMAGE_NAME = "${ECR_REPO}:${IMAGE_TAG}" // Full image name with tag
        CLUSTER_NAME = 'tester-cluster' // EKS cluster name
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/Bennymce/Deploying-to-eks-using-jenkins.git',
                    branch: 'main',
                    credentialsId: 'github-credentials'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Verify JAR File') {
            steps {
                sh 'ls -la target/myapp-1.0-SNAPSHOT.jar'
            }
        }

        stage('Login to AWS ECR') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                        // Login to ECR using IAM role
                        echo "Current AWS CLI configuration:"
                        // Optional: Display current IAM role
                        // sh "aws sts get-caller-identity"
                        sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}"
                    }
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
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                        // Update kubeconfig for the EKS cluster
                        sh "aws eks update-kubeconfig --name ${CLUSTER_NAME} --region ${AWS_REGION}"

                        // Apply the Kubernetes deployment configuration
                        sh 'kubectl apply -f jenkins-service-account.yaml --namespace=jenkins'
                        sh 'kubectl apply -f jenkins-role.yaml --namespace=jenkins'
                        sh 'kubectl apply -f jenkins-role-binding.yaml --namespace=jenkins'
                        sh 'kubectl apply -f java-app-deployment.yaml --namespace=jenkins'
                        
                        // Check the status of the pods
                        sh 'kubectl get pods --namespace=jenkins'
                    }
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

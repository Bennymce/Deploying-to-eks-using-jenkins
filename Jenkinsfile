pipeline {
    agent any
    tools {
        maven 'app-maven'
        dockerTool 'app-docker'
    }

    environment {
        AWS_REGION = 'us-east-2'
        ECR_REPO = '010438494949.dkr.ecr.us-east-2.amazonaws.com/jenkins-repo'
        BRANCH_NAME = "${env.GIT_BRANCH}".replaceAll('/', '-') // Replace slashes with dashes in branch name
        IMAGE_TAG = "${BRANCH_NAME}-${env.BUILD_ID}"
        IMAGE_NAME = "${ECR_REPO}:${IMAGE_TAG}" // Full image name with tag
        KUBECONFIG_PATH = "${WORKSPACE}/kubeconfig" // Path to kubeconfig in your workspace
        CLUSTER_NAME = 'newapp-cluster' // Replace with your EKS cluster name
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

        stage('Check Docker Installation') {
            steps {
                sh 'docker --version'
                sh 'docker info'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    sh "docker build -t ${IMAGE_NAME} ." // Build the Docker image with dynamic tag
                }
            }
        }

        stage('Scan Docker Image') {
            steps {
                sh "trivy image ${IMAGE_NAME}" // Scan the Docker image
            }
        }

        stage('Login to AWS ECR') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                        sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO}"
                    }
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    sh "docker tag ${IMAGE_NAME} ${ECR_REPO}:${IMAGE_TAG}"
                    sh "docker push ${ECR_REPO}:${IMAGE_TAG}" // Push Docker image to ECR with dynamic tag
                }
            }
        }

        stage('Load kubeconfig') {
            steps {
                script {
                    echo 'Loading kubeconfig...'
                    // This command retrieves the kubeconfig secret and saves it to a file
                    withCredentials([file(credentialsId: 'kubeconfig-secret', variable: 'KUBECONFIG_FILE')]) {
                        sh "cp ${KUBECONFIG_FILE} ${KUBECONFIG_PATH}"
                    }
                }
            }
        }

        stage('Check kubectl Configuration') {
            steps {
                script {
                    sh "kubectl --kubeconfig=${KUBECONFIG_PATH} get nodes" // Test if kubectl can access EKS
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    echo 'Deploying to EKS...'
                    // Update the image in the deployment file and apply to the cluster
                    sh "kubectl --kubeconfig=${KUBECONFIG_PATH} set image deployment/my-java-app-deployment my-java-app-container=${IMAGE_NAME}"
                    sh "kubectl --kubeconfig=${KUBECONFIG_PATH} rollout status deployment/my-java-app-deployment"
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

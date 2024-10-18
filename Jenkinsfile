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
        IMAGE_TAG = "${BRANCH_NAME}-${env.BUILD_ID}" // Use branch name and build ID for image tag
        IMAGE_NAME = "${ECR_REPO}:${IMAGE_TAG}" // Full image name with tag
        CLUSTER_NAME = 'java-cluster' // EKS cluster name
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

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    sh "docker build -t ${IMAGE_NAME} ." // Build Docker image with tag
                }
            }
        }

        stage('Scan Docker Image') {
            steps {
                sh "trivy image ${IMAGE_NAME}" // Scan the Docker image for vulnerabilities
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
                    sh "docker push ${IMAGE_NAME}" // Push Docker image to ECR
                }
            }
        }

        stage('Load kubeconfig') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'kubeconfig-secret', variable: 'KUBECONFIG_FILE')]) {
                        withEnv(["KUBECONFIG=${KUBECONFIG_FILE}"]) {
                        // No need for hardcoded KUBECONFIG_PATH
                        sh 'echo "KUBECONFIG: $KUBECONFIG"'
                        sh 'kubectl get nodes'
                    }
                }
            }
         }
        }       

        stage('Deploy to EKS') {
            steps {
                script {
                    echo 'Deploying to EKS...'
                    sh 'kubectl apply -f java-app-deployment.yaml'
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

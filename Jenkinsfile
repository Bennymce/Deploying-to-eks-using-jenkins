pipeline {
    agent any
    tools {
        maven 'app-maven' 
        dockerTool 'app-docker'
    }    

    environment {
        AWS_REGION = 'us-east-2'
        ECR_REPO = '010438494949.dkr.ecr.us-east-2.amazonaws.com/jenkins-repo'
        IMAGE_TAG = "my-java-app:${env.BUILD_ID}"
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

        // Verify JAR file exists after Maven build
        stage('Verify JAR File') {
            steps {
                script {
                    // Check if the JAR file exists in the target directory
                    sh 'ls -la target/myapp-1.0-SNAPSHOT.jar'
                }
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
                    echo 'Starting Docker build...'
                    try {
                        // Build the Docker image from the root folder where the Dockerfile is located
                        sh "docker build -t ${IMAGE_TAG} ."
                        echo 'Docker build completed successfully.'
                    } catch (err) {
                        echo 'Docker build failed.'
                        error 'Stopping pipeline due to build failure.'
                    }
                }
            }
        }

        stage('Scan Docker Image') {
            steps {
                script {
                    sh "trivy image ${IMAGE_TAG}"
                }
            }
        }

        
        stage('Login to AWS ECR') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                        def loginCommand = "aws ecr get-login-password --region ${AWS_REGION}"
                        sh "${loginCommand} | docker login --username AWS --password-stdin ${ECR_REPO}"
                    }
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    sh "docker tag ${IMAGE_TAG} ${ECR_REPO}:${env.BUILD_ID}"
                    sh "docker push ${ECR_REPO}:${env.BUILD_ID}"
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Clean workspace after the build
        }
    }
}

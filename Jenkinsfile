pipeline {
    agent any
    environment {
        ECR_REPO = 'your-aws-account-id.dkr.ecr.your-region.amazonaws.com/your-repo-name'
        IMAGE_TAG = 'latest'
        AWS_REGION = 'your-region'
    }
    tools {
        nodejs "NodeJS"  // Reference the Node.js installation in Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the repository
                git 'https://your-repo-url.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                // Install npm dependencies
                sh 'npm install'
            }
        }

        stage('Build Project') {
            steps {
                // Run the npm build script
                sh 'npm run build'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build the Docker image
                sh """
                docker build -t $ECR_REPO:$IMAGE_TAG .
                """
            }
        }

        stage('Login to ECR') {
            steps {
                // Log in to ECR
                sh """
                aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                // Push the Docker image to ECR
                sh """
                docker push $ECR_REPO:$IMAGE_TAG
                """
            }
        }
    }

    post {
        always {
            // Clean up workspace
            cleanWs()
        }
    }
}

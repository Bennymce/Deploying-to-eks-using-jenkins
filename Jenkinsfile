pipeline {
    agent any
    
    environment {
        AWS_ACCOUNT_ID = '010438494949'
        AWS_REGION = 'us-east-2'
        ECR_REPO_NAME = 'new-app'
        IMAGE_TAG = "${env.BUILD_ID}"
        DOCKER_IMAGE = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}"
    }
    
    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/Bennymce/Deploying-to-eks-using-jenkins.git', branch: 'main'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build Application') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Scan Image for Vulnerabilities') {
            steps {
                sh '''
                    # Install Trivy if not already installed
                    which trivy || curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh
                    # Scan Docker image
                    trivy image ${DOCKER_IMAGE} || exit 1
                '''
            }
        }

        stage('Login to ECR') {
            steps {
                script {
                    sh '''
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                    '''
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    dockerImage.push("${IMAGE_TAG}")
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

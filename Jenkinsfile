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
        CLUSTER_NAME = 'benny-java-cluster' // EKS cluster name
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
                    sh 'aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin ${ECR_REPO}'
                }
            }
        }

        stage('Tag and Push Docker Image to ECR') {
            steps {
                script {
                    sh "docker tag ${IMAGE_NAME} ${ECR_REPO}:${IMAGE_TAG}"
                    sh "docker push ${ECR_REPO}:${IMAGE_TAG}"
                }
            }
        }

        stage('Kubeconfig') {
            steps {
                script {
                    withKubeCredentials(kubectlCredentials: [[
                        caCertificate: '', 
                        clusterName:  ${CLUSTER_NAME}, 
                        contextName: '', // Provide a valid context name if needed
                        credentialsId: 'kubeconfig-secret', 
                        namespace: '', // Specify the namespace if needed
                        serverUrl: 'https://100E584D809B03C2057ADE0FC1AD625E.gr7.us-east-2.eks.amazonaws.com'
                    ]]) {
                        sh 'kubectl get nodes'
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    echo 'Deploying to EKS...'
                    sh 'kubectl apply -f java-app-deployment.yaml' 
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

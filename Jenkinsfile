pipeline {
    agent any
    
    environment {
        AWS_ACCOUNT_ID = '010438494949'
        AWS_REGION = 'us-east-2'
        ECR_REPO_NAME = 'jenkins-repo'
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
    }
}
//         stage('Build Docker Image') {
//             steps {
//                 script {
//                     // Ensure Docker plugin is available
//                     if (!docker.isAvailable()) {
//                         error "Docker plugin is not installed or configured correctly."
//                     }
//                     dockerImage = docker.build("${DOCKER_IMAGE}")
//                 }
//             }
//         }

//         stage('Scan Image for Vulnerabilities') {
//             steps {
//                 script {
//                     // Ensure Trivy is installed
//                     sh 'which trivy || curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh'
//                     // Scan Docker image
//                     def scanResult = sh(script: "trivy image ${DOCKER_IMAGE}", returnStatus: true)
//                     if (scanResult != 0) {
//                         error "Trivy scan failed."
//                     }
//                 }
//             }
//         }

//         stage('Login to ECR') {
//             steps {
//                 withCredentials([usernamePassword(credentialsId: 'aws-ecr-credentials', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
//                     script {
//                         sh '''
//                             aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
//                         '''
//                     }
//                 }
//             }
//         }

//         stage('Push Docker Image to ECR') {
//             steps {
//                 script {
//                     // Ensure Docker plugin is available
//                     if (!docker.isAvailable()) {
//                         error "Docker plugin is not installed or configured correctly."
//                     }
//                     dockerImage.push("${IMAGE_TAG}")
//                 }
//             }
//         }
//     }

//     post {
//         always {
//             cleanWs()
//         }
//     }
// }

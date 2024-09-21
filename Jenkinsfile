pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-2' // Update the region as needed
        ECR_REPO = '010438494949.dkr.ecr.us-east-2.amazonaws.com/jenkins-repo'
        IMAGE_TAG = "my-java-app:${env.BUILD_ID}"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/Bennymce/Deploying-to-eks-using-jenkins.git' // Update with your repository
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }
    }
} 
//         stage('Build Docker Image') {
//             steps {
//                 script {
//                     docker.build("${IMAGE_TAG}", ".")
//                 }
//             }
//         }

//         stage('Scan Docker Image') {
//             steps {
//                 script {
//                     // Use a tool like Trivy for scanning, assuming it is installed
//                     sh 'trivy image ${IMAGE_TAG}'
//                 }
//             }
//         }

//         stage('Login to AWS ECR') {
//             steps {
//                 script {
//                     sh '''
//                     $(aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO)
//                     '''
//                 }
//             }
//         }

//         stage('Push to ECR') {
//             steps {
//                 script {
//                     sh 'docker tag ${IMAGE_TAG} ${ECR_REPO}:${env.BUILD_ID}'
//                     sh 'docker push ${ECR_REPO}:${env.BUILD_ID}'
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

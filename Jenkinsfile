pipeline {
    agent any
    tools {
        maven 'app-maven' // Replace with your Maven version
    }    

    environment {
        AWS_REGION = 'us-east-2' // Update the region as needed
        ECR_REPO = '010438494949.dkr.ecr.us-east-2.amazonaws.com/jenkins-repo'
        IMAGE_TAG = "my-java-app:${env.BUILD_ID}"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/Bennymce/Deploying-to-eks-using-jenkins.git', 
                    branch: 'main', // Change 'main' to your branch if different
                    credentialsId: 'github-credentials'
            }   
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        

   
        stage('List Root Directory') {
            steps {
                sh 'ls -la'
            }
        }
    

        stage('List Target Directory') {
            steps {
                sh 'ls -la target'
            }
        }
        
        stage('Check Dockerfile') {
            steps {
                sh 'ls -la'
            }
        }



        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    //sh 'docker build -t "$JD_IMAGE" .'
                    echo "Building Docker image with tag: ${IMAGE_TAG}"
                    docker.build("${IMAGE_TAG}", ".")
                }
            }
        }

        stage('Scan Docker Image') {
            steps {
                script {
                    // Use a tool like Trivy for scanning, assuming it is installed
                    sh "trivy image ${IMAGE_TAG}"
                }
            }
        }

    //     stage('Login to AWS ECR') {
    //         steps {
    //             script {
    //                 // Use withCredentials to bind AWS credentials
    //                 withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
    //                     // Login to AWS ECR
    //                     def loginCommand = "aws ecr get-login-password --region ${AWS_REGION}"
    //                     sh "${loginCommand} | docker login --username AWS --password-stdin ${ECR_REPO}"
    //                 }
    //             }
    //         }
    //     }

    //     stage('Push to ECR') {
    //         steps {
    //             script {
    //                 // Tag the image and push to ECR
    //                 sh "docker tag ${IMAGE_TAG} ${ECR_REPO}:${env.BUILD_ID}"
    //                 sh "docker push ${ECR_REPO}:${env.BUILD_ID}"
    //             }
    //         }
    //     }
    // }

    // post {
    //     always {
    //         cleanWs() // Clean workspace after the build
    //     }
    }
}

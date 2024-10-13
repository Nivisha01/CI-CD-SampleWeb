pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "nivisha/myapp:${BUILD_NUMBER}"
        PROD_SERVER = "172.31.38.178"
    }

    stages {
        stage('Clone from GitHub') {
            steps {
                git branch: 'master', url: 'https://github.com/Nivisha01/CI-CD-SampleWeb.git'
            }
        }

        stage('Build the Application') {
            steps {
                script {
                    sh 'mvn clean package'  // Replace with your actual build command
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', 'DockerHub') {
                        // No need for manual docker login here
                    }
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    docker.image("${DOCKER_IMAGE}").push()
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                script {
                    sshagent(['SSH-Jenkins']) {  // Replace 'SSH-Jenkins' with your actual SSH credentials ID
                        sh '''
                        ssh jenkins@${PROD_SERVER} '
                        docker pull ${DOCKER_IMAGE} &&
                        docker stop myapp || true &&
                        docker rm myapp || true &&
                        docker run -d --name myapp -p 8003:8080 ${DOCKER_IMAGE}'
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()  // Clean workspace after the job
        }
    }
}

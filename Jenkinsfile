pipeline {
    agent any

    tools {
        maven "Maven"  // Specify the Maven installation in Jenkins
        jdk 'Java 17'  // Ensure that the JDK is configured in Jenkins
    }

    environment {
        DOCKER_IMAGE = "nivi/samplewebapp:${env.BUILD_NUMBER}" // Use build number for unique tagging
        PRODUCTION_SERVER = "jenkins@172.31.38.178" // Use the private IP for SSH
    }

    stages {
        stage('Checkout') {
            steps {
                // Clone the source code from Git
                git branch: 'master', url: 'https://github.com/Nivisha01/CI-CD-SampleWeb.git'
            }
        }

        stage('Build WAR') {
            steps {
                // Build the project and create a WAR file
                sh 'mvn clean package'
            }
        }

        stage('Docker Build') {
            steps {
                // Build the Docker image
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Publish to Docker Hub') {
            steps {
                // Push the Docker image to Docker Hub
                withDockerRegistry([ credentialsId: 'DockerHub', url: '' ]) {
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Run Docker Container on Remote Server') {
            steps {
                // SSH into the production server and run the Docker container
                withCredentials([sshUserPrivateKey(credentialsId: 'SSH_Jenkins', keyFileVariable: 'SSH_KEY_FILE')]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no -i \$SSH_KEY_FILE ${PRODUCTION_SERVER} '
                        docker run -d -p 8003:8080 ${DOCKER_IMAGE}'
                    """
                }
            }
        }

        stage('Cleanup') {
            steps {
                // Optional: Clean up old Docker images or containers
                withCredentials([sshUserPrivateKey(credentialsId: 'SSH_Jenkins', keyFileVariable: 'SSH_KEY_FILE')]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no -i \$SSH_KEY_FILE ${PRODUCTION_SERVER} '
                        docker rm -f \$(docker ps -aq) || true; 
                        docker rmi \$(docker images -f "dangling=true" -q) || true'
                    """
                }
            }
        }
    }

    post {
        always {
            // Archive the artifacts if necessary
            archiveArtifacts artifacts: '**/target/*.war', fingerprint: true
        }
        failure {
            // Handle failure (optional)
            echo 'Pipeline failed!'
        }
    }
}

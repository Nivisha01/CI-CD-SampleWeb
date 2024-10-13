pipeline {
    agent any

    tools {
        maven "Maven"  // Specify the Maven installation in Jenkins
        jdk 'Java 17'  // Ensure that the JDK is configured in Jenkins
    }

    environment {
        DOCKER_IMAGE = "my-sample-app:${env.BUILD_ID}"
        REMOTE_SERVER = "ec2-user@172.31.38.178"  // Change this to your server's SSH details
    }

    stages {
        stage('Cleanup Workspace') {
            steps {
                cleanWs()  // Clean the workspace to avoid conflicts
            }
        }
        stage('Clone Repository') {
            steps {
                git 'https://github.com/Nivisha01/CI-CD-SampleWeb.git'
            }
        }
        stage('Build WAR') {
            steps {
                // Build the project and create a WAR file
                sh 'mvn clean package'
                // List the target directory to verify the WAR file exists
                sh 'ls -l target/'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    dockerImage = docker.build(DOCKER_IMAGE)
                }
            }
        }
        stage('Deploy to Docker Container') {
            steps {
                script {
                    // Save the Docker image to a tar file
                    sh "docker save ${DOCKER_IMAGE} -o ${DOCKER_IMAGE}.tar"

                    // Transfer the Docker image to the remote server
                    sh "scp ${DOCKER_IMAGE}.tar ${REMOTE_SERVER}:/tmp"

                    // Load the Docker image on the remote server
                    sh "ssh ${REMOTE_SERVER} 'docker load -i /tmp/${DOCKER_IMAGE}.tar'"

                    // Run the Docker container on the remote server
                    sh "ssh ${REMOTE_SERVER} 'docker run -d -p 8003:8080 ${DOCKER_IMAGE}'"

                    // Optionally, clean up the tar file on the remote server
                    sh "ssh ${REMOTE_SERVER} 'rm /tmp/${DOCKER_IMAGE}.tar'"
                }
            }
        }
    }
}

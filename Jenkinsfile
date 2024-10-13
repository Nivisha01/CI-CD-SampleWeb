pipeline {
    agent any 

    stages {
        stage('Build') {
            steps {
                script {
                    // Run your build tool (e.g., Maven) to create the WAR file
                    sh 'mvn clean package' // Change this line if using a different build tool
                }
            }
        }
        
        stage('Docker Build') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t nivisha/mywebapp:latest .'
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    // Login to Docker Hub
                    withCredentials([usernamePassword(credentialsId: 'DockerHub', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh 'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin'
                        
                        // Push the Docker image to Docker Hub
                        sh 'docker push nivisha/mywebapp:latest'
                    }
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    // Pull the Docker image on the production server
                    sh 'ssh ec2-user@172.31.38.178 "docker pull nivisha/mywebapp:latest"'
                    
                    // Run the Docker container
                    sh 'ssh ec2-user@172.31.38.178 "docker run -d -p 8003:8080 nivisha/mywebapp:latest"'
                }
            }
        }
    }
}

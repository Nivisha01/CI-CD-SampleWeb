pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/Nivisha01/CI-CD-SampleWeb.git'
            }
        }
        stage('Build and Package WAR File') {
            steps {
                sh 'mvn clean package'  // This builds the WAR file
                sh 'ls -l target/'      // List the contents of the target directory to verify the WAR file
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("my-sample-app:${env.BUILD_ID}")
                }
            }
        }
        stage('Deploy to Docker Container') {
            steps {
                script {
                    dockerImage.run('-p 8003:8080')
                }
            }
        }
    }
}

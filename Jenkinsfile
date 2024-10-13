pipeline {
    agent any

    tools {
        maven "Maven"  // Specify the Maven installation in Jenkins
        jdk 'Java 17'  // Ensure that the JDK is configured in Jenkins
    }

    stages {
        stage('Checkout') {
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
        
        stage('Docker Build and Tag') {
           steps {
              
                sh 'docker build -t samplewebapp:latest .' 
                sh 'docker tag samplewebapp nivi/samplewebapp:latest'
                //sh 'docker tag samplewebapp nivi/samplewebapp:$BUILD_NUMBER'
               
          }
        }
        
        stage('Publish image to Docker Hub') {
          
            steps {
        withDockerRegistry([ credentialsId: "DockerHub", url: "" ]) {
          sh  'docker push nivi/samplewebapp:latest'
        //  sh  'docker push nivi/samplewebapp:$BUILD_NUMBER' 
        }
            }
        }

        stage('Run Docker container on Jenkins Agent') {
             
            steps 
			{
                sh "docker run -d -p 8003:8080 nivi/samplewebapp"
 
            }

            stage('Run Docker container on remote hosts') {
             
            steps {
                sh "docker -H ssh://ec2-user@172.31.34.58 run -d -p 8003:8080 nivi/samplewebapp"
            }
            }
        }
    }
}

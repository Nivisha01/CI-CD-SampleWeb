pipeline {
    agent any
	
	  tools
    {
       maven "Maven"
    }
 stages {
      stage('checkout') {
           steps {
             
                git branch: 'master', url: 'https://github.com/Nivisha01/CI-CD-SampleWeb.git'
             
          }
        }
	 stage('Execute Maven') {
           steps {
             
                sh 'mvn clean package'             
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
        }
 stage('Run Docker container on remote hosts') {
             
            steps {
                sh "docker -H ssh://ec2-user@172.31.38.178 run -d -p 8003:8080 nivi/samplewebapp"
 
            }
        }
    }
}
    

pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "nivisha/my-app:${BUILD_NUMBER}"
        PROD_SERVER = "172.31.38.178"
        SSH_CREDENTIALS_ID = "SSH-Jenkins"
        GIT_CREDENTIALS_ID = "GitHub"  // GitHub credentials for pushing to repo
    }

    stages {
        stage('Clone from GitHub') {
            steps {
                git branch: 'master', url: 'https://github.com/Nivisha01/CI-CD-SampleWeb.git'
            }
        }

        stage('Build and Package WAR File') {
            steps {
                sh 'mvn clean package'  // This builds the WAR file
                sh 'ls -l target/'      // List the contents of the target directory to verify the WAR file
            }
        }

        stage('Push WAR File to GitHub') {
            steps {
                script {
                    // Configure git user details
                    sh 'git config user.email "nivishaanand01@gmail.com"'
                    sh 'git config user.name "Nivisha01"'

                    // Copy the .war file to the root of the repository (or any other location)
                    sh 'cp target/LoginWebApp.war .'

                    // Add the WAR file to the repository
                    sh 'git add LoginWebApp.war'

                    // Commit the new .war file
                    sh 'git commit -m "Add new WAR file [${BUILD_NUMBER}]"'

                    // Push changes to GitHub
                    withCredentials([usernamePassword(credentialsId: '${GIT_CREDENTIALS_ID}', passwordVariable: 'GIT_TOKEN', usernameVariable: 'GIT_USER')]) {
                        sh 'git push https://${GIT_USER}:${GIT_TOKEN}@github.com/your-repo.git HEAD:master'
                    }
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

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', 'DockerHub') {
                        docker.image("${DOCKER_IMAGE}").push()
                    }
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                script {
                    sshagent (credentials: ['${SSH_CREDENTIALS_ID}']) {
                        sh '''
                        ssh user@${PROD_SERVER} '
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

pipeline {
    agent any

    environment {
        imagename = "ouchcs/springproject"
        registryCredential = 'docker'
        dockerImage = ''
    }

    stages {
        stage('Bulid Gradle') {
          steps {
            echo 'Bulid Gradle'
            dir('.'){
                sh './gradlew clean build'
            }
          }
          post {
            failure {
              error 'This pipeline stops here...'
            }
          }
        }
        
        stage('Bulid Docker') {
          steps {
            echo 'Bulid Docker'
            script {
                dockerImage = docker.build imagename
            }
          }
          post {
            failure {
              error 'This pipeline stops here...'
            }
          }
        }

        stage('Push Docker') {
          steps {
            echo 'Push Docker'
            script {
                docker.withRegistry( '', registryCredential) {
                    dockerImage.push() 
                }
            }
          }
          post {
            failure {
              error 'This pipeline stops here...'
            }
          }
        }
        
        stage('Docker Run') {
            steps {
                echo 'Pull Docker Image & Docker Image Run'
                sshagent (credentials: ['ssh']) {
                    sh "ssh -o StrictHostKeyChecking=no ubuntu@13.125.219.143 'docker pull ouchcs/springproject'" 
                    sh "ssh -o StrictHostKeyChecking=no ubuntu@13.125.219.143 'docker ps -q --filter name=spring | grep -q . && docker rm -f \$(docker ps -aq --filter name=spring)'"
                    sh "ssh -o StrictHostKeyChecking=no ubuntu@13.125.219.143 'docker run -d --name spring -p 8080:8080 ouchcs/springproject'"
                }
            }
        }
    }
    post {
        success {
            slackSend (channel: 'spring-project', color: '#00FF00', message: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }
        failure {
            slackSend (channel: 'spring-project', color: '#FF0000', message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }
    }
}

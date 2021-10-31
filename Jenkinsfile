pipeline {
    agent any
    stages {
        stage('Build Application') {
            steps {

                bat 'mvn -f ./my-app/pom.xml package sonar:sonar -Dsonar.login=c3ecc1b7d6d7239c5681d0df589e97c52368ffd1'
                
            }

        }
        stage('Building our image') { 
            steps { 
                script { 
                    docker build app-test:$BUILD_NUMBER
                }
            } 
        }
        stage('Run Container'){
                steps {
                    script{withCredentials([usernamePassword(credentialsId: 'gtaa', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    docker.withRegistry('', 'gtaa') {
                    sh "docker pull gtaa/maven-application-assignment:1.0.0"
                    sh "docker run gtaa/maven-application-assignment:1.0.0"
                    }
                    }
                    }
                }
        }
        stage('QA environment(Executed only for testing branch)'){
           when {
                 expression { return env.GIT_BRANCH == 'origin/QA_Branch'; }
                }
                steps {
                   bat 'mvn -f ./my-app/pom.xml test'
                   }
                post {
                    always {
                      emailext body: 'Notification Email', recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: 'Production Notificat'
                      }
                    success {
                       echo "Selenium Test Cases Passed"
                    }
                }
        }
    }
}

def user
node {
  wrap([$class: 'BuildUser']) {
    user = env.BUILD_USER_ID
  }
emailext mimeType: 'text/html',
                 subject: "[Jenkins]${currentBuild.fullDisplayName}",
                 to: "ghatasaxena27@gmail.com",
                 body: '''<a href="${BUILD_URL}input">click to approve</a>'''
}

pipeline {

   environment {
        dockerImage = 'maven-application-assignment'
    }

    agent any
    stages {

     /*   stage('Building our image') { 
            steps { 
                script { 
                    dockerImage = docker.build dockerImage + ":$BUILD_NUMBER" 
                }
            } 
        }*/


        stage('Execute Cotainer') {
               steps {
                    script
                    { withCredentials([usernamePassword(credentialsId: 'gtaa', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) 
                        {
                        docker.withRegistry('', 'gtaa') {
                            sh "docker pull gtaa/maven-application-assignment:1.0.0"
                            sh "docker run gtaa/maven-application-assignment:1.0.0"
                            }
                        }
                    }
                }
        }

        stage('QA environment'){
           when {
                 expression { return env.GIT_BRANCH == 'origin/QA_Branch'; }
                }
              try {
                steps {
                   bat 'mvn -f ./my-app/pom.xml test'
                   }
                 currentBuild.result = 'SUCCESS'
                   }
                   catch (err) {
                       currentBuild.result = 'FAILURE'
                     }


                post {
                    always {
                     mail to: 'ghatasaxena27@gmail.com',
          subject: "Status of pipeline: ${currentBuild.fullDisplayName}",
          body: "${env.BUILD_URL} has result ${currentBuild.result}"

                     }
                }

        }

        stage('Deploy to Production') {
                  input{
                        message "Should we continue?"
                        ok "Yes"
                    }
                    when {
                        expression { user == 'hardCodeApproverJenkinsId'}
                    }

            steps {
                 echo "Deploying to Production"
                 bat 'mvn -f ./my-app/pom.xml package'
            }
            post {
                always {
                emailext body: 'Notification Email', recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: 'Production Notificat'
                }
            }
        }
    
    }
}


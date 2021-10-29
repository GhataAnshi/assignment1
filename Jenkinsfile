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
    agent any
    stages {
        stage('Scan using SonarQube') {
            steps {
                echo "Pulling "+env.GIT_BRANCH
                //bat 'mvn -f ./my-app/pom.xml package sonar:sonar -Dsonar.login=c3ecc1b7d6d7239c5681d0df589e97c52368ffd1'
                
            }

        }
        stage('QA environment'){
           when {
                 expression { return env.GIT_BRANCH == 'origin/QA_Branch'; }
                }
                steps {
                          echo env.BUILD_USER_ID
			  bat 'mvn -f ./my-app/pom.xml test'
                   }
                post {
                 success {
                       echo "Selenium Test Cases Passed"
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


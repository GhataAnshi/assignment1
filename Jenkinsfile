def user
node {
  wrap([$class: 'BuildUser']) {
    user = env.BUILD_USER_ID
  }
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
         				steps{
				script{
                  try {
                     sh 'mvn -f ./my-app/pom.xml test'
                     currentBuild.result = 'SUCCESS'
                   }
                   catch (err) {
                       currentBuild.result = 'FAILURE'
                     }
                   }
                   }
                post {
                    always {
               mail to: 'ghatasaxena27@gmail.com',
      subject: "Status of pipeline: ${currentBuild.fullDisplayName}",
      body: """Hi, The last buil result is ${currentBuild.result}.
Please <a href="${env.BUILD_URL}input/">approve me</a>!
"""
                     }
                }

        }

        stage('Deploy to Production') {
		                  input{
                        message "Should we continue?"
                        ok "Yes"
                    }
            steps {
                 echo "Deploying to Production"
                 bat 'mvn -f ./my-app/pom.xml package'
		 sh 'java -cp $HOME/my-app/target/my-app-1.0-SNAPSHOT.jar com.mycompany.app.App'
            }
            post {
		    always{
                mail to: 'ghatasaxena27@gmail.com',
      subject: "Status of pipeline: ${currentBuild.fullDisplayName}",
      body: "Hi, The last buil result is ${currentBuild.result}."
                     }
            }
        }
    
    }
}


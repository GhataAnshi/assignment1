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

        stage('Code pull from Github') { 
            steps { 
                checkout scm
            } 
        }
        stage('Build Application') { 
            steps { 
                sh ' mvn -f ./my-app/pom.xml clean package'
            } 
        }

        stage('Scan with SonarQube') { 
            steps { 
                withSonarQubeEnv('sonarqube'){
                   bat 'mvn -f ./my-app/pom.xml sonar:sonar'
                }
            } 
        }

        stage('Test the QA_Branch') { 
            when{
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
                        Please <a href="${env.BUILD_URL}input/">Click link to approve</a>!
                        """
                        }
                    }
            }

        stage('Building docker image') { 
            steps { 
                script { 
                    dockerImage = docker.build dockerImage 
                }
            } 
        }
        stage('Build Docker Image, Push to Repositoy') {
                input{
                        message "Should we continue?"
                        
                    }
                steps {
                    script{withCredentials([usernamePassword(credentialsId: 'gtaa', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        docker.withRegistry('', 'gtaa') {
                            sh "docker tag maven-application-assignment gtaa/maven-application-assignment:${BUILD_NUMBER}"
                            sh "docker push gtaa/maven-application-assignment:${BUILD_NUMBER}"
                        }
                    }}
                }
        }

        stage('Executing Docker Container') {

            steps {
                    script {
                        docker.withRegistry('', 'gtaa') {
                        sh "docker pull gtaa/maven-application-assignment:${BUILD_NUMBER}"
                        sh "docker run gtaa/maven-application-assignment:${BUILD_NUMBER}"
                        }
                    }
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


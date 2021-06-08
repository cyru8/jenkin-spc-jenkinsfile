pipeline {
    // agent any
    agent {
        label 'agent-mavencore'
    }
    // triggers { pollSCM('H/5 * * * *') }
    stages {
        stage('Verify Branch') {
            steps {
                echo "${env.GIT_BRANCH}"
                slackSend message: "Build Started - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL} | Link>)"
           }
        }
        stage('checkout') {
            steps {
                echo "${env.GIT_BRANCH}"
                sh "pwd"
                sh "ls -al"
            }
        }
        stage('Clean and Build the Pet Clinic Java App') {
            steps {
                sh "./mvnw clean package"
                slackSend message: "Build Completed - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL} | Link>)"
                echo "deploy this app into a docker image for deployment."
            }
            post {
                always {
                    junit '**/target/surefire-reports/TEST-*.xml'
                    archiveArtifacts 'target/*.jar'
                    sh 'echo "JUnit Test Completed."'
                }
                changed {
                    emailext subject: "Job \'${JOB_NAME}\' (${BUILD_NUMBER}) ${currentBuild.result}",
                    attachLog: true,
                    compressLog: true,
                    body: "Please go to ${BUILD_URL} and verify the build",
                    to: 'test@jenkins',
                    recipientProviders: [upstreamDevelopers(), requestor()]
                }
            }
        }
        stage('Package application into a docker image') {
            steps {
                sh(script: """
                docker build -t oadetiba/spring-petclinic:2.3.1 .
                docker images
                """)
            }
            
        }
    }
}
pipeline {
    agent any
    triggers { pollSCM('* * * * *') }
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
        stage('Clean and Build the Pet Clinic App') {
            steps {
                sh "./mvnw clean package"
                // sh "false" //true
            }
            post {
                always {
                    junit '**/target/surefire-reports/TEST-*.xml'
                    archiveArtifacts 'target/*.jar'
                }
                changed {
                    emailext subject: "Job \'${JOB_NAME}\' (${BUILD_NUMBER}) ${currentBuild.result}",
                    attachLog: true,
                    compressLog: true,
                    body: "Please go to ${BUILD_URL} and verify the build",
                    to: 'test@jenkins',
                    recipientProviders: [upstreamDevelopers(), requestor()]
                    slackSend message: "Build Completed - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL} | Link>)"
                }
            }
        }
    }
}
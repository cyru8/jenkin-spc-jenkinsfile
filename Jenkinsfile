pipeline {
    agent any
    triggers { pollSCM('* * * * *') }

    //tools {
        // Install the Maven version configured as "M3" and add it to the path.
    //    maven "M3"
    //}

    stages {
        stage('Verify Branch') {
            steps {
                echo "${env.GIT_BRANCH}"
                slackSend message: "Build Started - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL} | Link>)"
                sh "docker version"
           }
        }
        //stage('Build') {
        stage('checkout') {
            steps {
                // Get some code from a GitHub repository
                //git 'https://github.com/jglick/simple-maven-project-with-tests.git'
                echo "${env.GIT_BRANCH}"
                sh "pwd"
                sh "ls -al"
                // git url: 'https://github.com/g0t4/jgsu-spring-petclinic.git', branch: 'main'

                // Run Maven on a Unix agent.
                //sh "mvn -Dmaven.test.failure.ignore=true clean package"
            }
        }
        stage('Clean and Build the Pet Clinic App') {
            steps {
                sh "./mvnw clean package"
                // sh "false" //true
            }
        // }    
                // sh "./mvnw clean package"

                // To run Maven on a Windows agent, use
                // bat "mvn -Dmaven.test.failure.ignore=true clean package"
            // }

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
pipeline {
    environment {
    registry = "oadetiba/spring-petclinic"
    registryCredential = 'dockerhubcreds'
    dockerImage = ''
    }
    //agent any
    agent {
        label 'docker'
    }
    //triggers {
       // poll repo every minute for changes
       //pollSCM('* * * * *')
    //}
    options {
       // add timestamps to output
       timestamps()
       overrideIndexTriggers(false)
       buildDiscarder(logRotator(numToKeepStr: '10'))
       skipStagesAfterUnstable()
       durabilityHint('PERFORMANCE_OPTIMIZED')
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
                    body: "JUnit test ran successfully, please go to ${BUILD_URL} and verify the build",
                    to: 'test@jenkins',
                    recipientProviders: [upstreamDevelopers(), requestor()]
                }
            }
        }
        // stage('Package application into a docker image') {
        //     steps {
        //         sh(script: """
        //         docker build -t oadetiba/spring-petclinic:2.3.1 .
        //         docker images
        //         """)
        //     }

        // }
        stage("Build image with the Spring Pet Clinic App and Push the Image to Docker Registry") {
            steps {
                echo "Workspace is $WORKSPACE"
                dir("$WORKSPACE") {
                    script {
                        docker.withRegistry('', 'dockerhubcreds') {
                            def image = docker.build('oadetiba/spring-petclinic:v$BUILD_NUMBER')
                            echo "Please proceed to push the images: spring-petclinic"
                            image.push()
                slackSend message: "spring-petclinic image built and pushed - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL} | Link>)"
                        }
                    }
                }
            }
        }
        // stage('build') {
        //     steps {
        //         dockerImage = docker.build('oadetiba/spring-petclinic:v$BUILD_NUMBER', '.')
        //         docker.withRegistry('https://index.docker.io/v1/', 'dockerhubcreds') {
        //             dockerImage.push()
        //         }
        //     }
	    // }
        stage('Remove docker image once pushed to docker registry') {
            steps{
                sh "docker rmi $registry:v$BUILD_NUMBER"
                // sh 'docker images -a | grep "years" | awk "{print $3}" | xargs docker rmi --force'
            }
        }
    }
}

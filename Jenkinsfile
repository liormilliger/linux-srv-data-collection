pipeline {

    agent any

    environment {
        GIT_SSH_KEY = "GitHub-key"
        APP_REPO = 'git@github.com:liormilliger/linux-srv-data-collection.git'
        IMAGE_NAME = 'monitor-app'
        ECR_REG = '704505749045.dkr.ecr.us-east-1.amazonaws.com/liorm-nanox'
    }

    options {
        timestamps() // Add timestamps to the console output
        timeout(time: 10, unit: 'MINUTES') // Set a timeout for the pipeline execution    
    }

    stages {
        stage ("CHECKOUT") {
            steps {
                checkout scm
            }
        }

        stage ("BUILD APP IMAGE") {
            steps {
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage("Test"){
            stages {
                stage ("Container UP") {
                    steps {
                            echo "========CONTAINERS UP=========="
                            sh "docker run --name web-monitor-${BUILD_NUMBER} -p 80:80 ${IMAGE_NAME}"
                        // }
                    }
                }
                stage("Health Check") {
                    steps {
                        script {
                            def retries = 10
                            def waitTimeSeconds = 5
                            def url = 'http://localhost:80'
                            
                            def success = false
                            for (int i = 0; i < retries; i++) {
                                def response = sh(script: "curl -sfSLI ${url}", returnStatus: true)
                                
                                if (response == 0) {
                                    echo "Health check succeeded. HTTP response code: 200"
                                    success = true
                                    break
                                }
                                else {
                                    echo "Health check failed. Retrying in ${waitTimeSeconds} seconds..."
                                    sleep waitTimeSeconds
                                }
                            }

                            if (!success) {
                                error "Health check failed after ${retries} retries"
                            }
                        }
                    }
                }
            }
            post {
                always {
                    // Shut down Docker containers after testing
                    sh """
                        docker stop web-monitor-${BUILD_NUMBER}
                        docker rm web-monitor-${BUILD_NUMBER}
                        docker volume prune -f
                    """
                }
            }
        }

        stage("PUBLISH IMAGE"){
            stages {
                stage("Tag Image"){
                    sh """
                        docker tag ${IMAGE_NAME} ${ECR_REG}:monitor-app
                    """
                }
                stage("Push Image"){
                    sh """
                        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 704505749045.dkr.ecr.us-east-1.amazonaws.com
                        docker push ${ECR_REG}:monitor-app
                    """
                }
            }
        }
    }
    post {
        always {

            cleanWs()
            // Clean up unused Docker resources
            sh '''
                docker image prune -af
                docker volume prune -af
                docker container prune -f
                docker network prune -f
            '''
        }
    }        
}
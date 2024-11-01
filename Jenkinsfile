pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'omarelk18/nodejschatappsast'
        GIT_REPO = 'https://github.com/Omarelk17/nodejschatappsast'
    }

    stages {
        stage('Clone and Build') {
            steps {
                script {
                    echo 'Cloning GitHub Repository and Building Docker Image...'
                    
                    // Clone the repository
                    git branch: 'main', url: "${env.GIT_REPO}"

                    // Clean up previous builds (optional)
                    sh "docker compose -f docker-compose.yml down || true"
                    sh "docker image rm -f ${DOCKER_IMAGE}:latest || true"
                    sh "docker image rm -f ${DOCKER_IMAGE}:${BUILD_NUMBER} || true"

                    // Build the Docker image
                    sh "docker compose -f docker-compose.yml build app"
                    sh "docker tag omarelk18/nodejschatapp ${DOCKER_IMAGE}:latest"
                    sh "docker tag omarelk18/nodejschatapp ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    echo 'Pushing Docker Image to Docker Hub...'
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        // Log in to Docker Hub
                        sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"

                        // Push images to Docker Hub
                        sh "docker push ${DOCKER_IMAGE}:latest"
                        sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                    }
                }
            }
        }

        stage('Run Application') {
            steps {
                script {
                    echo 'Running Docker Application with Docker Compose...'
                    
                    // Start the application in detached mode
                    sh "docker compose -f docker-compose.yml up -d"
                }
            }
        }
    }

    post {
        always {
            script {
                echo 'Cleaning up unused Docker resources...'
                // Stop containers and clean up dangling images
                sh "docker compose -f docker-compose.yml down"
                sh "docker system prune -f"
            }
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs for errors.'
        }
    }
}

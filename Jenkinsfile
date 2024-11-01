pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'omarelk18/nodejschatappsast'
        GIT_REPO = 'https://github.com/Omarelk17/NodejsChatAppSAST'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: "${env.GIT_REPO}"
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker compose -f docker-compose.yml build'
            }
        }

        stage('Snyk Security Scan') {
            steps {
                script {
                    try {
                        sh 'snyk test' // Run Snyk scan
                    } catch (Exception e) {
                        error "Build failed due to vulnerabilities detected by Snyk."
                    }
                }
            }
        }

        stage('Run Application') {
            steps {
                sh 'docker compose -f docker-compose.yml up -d'
                sleep 15 // Allow time for the app to start
            }
        }

        stage('Test Application') {
            steps {
                script {
                    def response = sh(script: "curl -s -o /dev/null -w '%{http_code}' http://localhost:3700", returnStdout: true).trim()
                    if (response != '200') {
                        error "Application is not running! HTTP Response: ${response}"
                    } else {
                        echo "Application is running successfully! HTTP Response: ${response}"
                    }
                }
            }
        }
    }

    post {
        always {
            sh 'docker compose -f docker-compose.yml down'
        }
    }
}

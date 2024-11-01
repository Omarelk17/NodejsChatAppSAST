pipeline {
    agent any
    environment {
        SNYK_TOKEN = credentials('snyk-api-token') // Snyk API token from Jenkins credentials
    }
    stages {
        stage('Checkout') {
            steps {
                // Clone the GitHub repository
                git url: 'https://github.com/Omarelk17/NodejsChatAppSAST'
            }
        }
        stage('Build') {
            steps {
                script {
                    // Build Docker image with the specified name
                    sh 'docker build -t omarelk18/nodejschatappsast .'
                }
            }
        }
        stage('Security Testing') {
            steps {
                script {
                    // Install Snyk if not already installed
                    sh 'npm install -g snyk'
                    
                    // Run Snyk SCA for dependency vulnerabilities
                    sh 'snyk test --severity-threshold=high || true'
                    
                    // Run Snyk SAST for code vulnerabilities
                    sh 'snyk code test --severity-threshold=high || true'
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Run the Docker container from the built image
                    sh 'docker run -d -p 3700:3700 --name nodejschatapp omarelk18/nodejschatappsast'
                }
            }
        }
    }
    post {
        always {
            script {
                // Clean up any previous containers with the same name
                sh 'docker rm -f nodejschatapp || true'
            }
        }
    }
}

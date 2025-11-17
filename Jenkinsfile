pipeline {
agent any

environment {
        GIT_CREDENTIALS = 'github-pat'
    }

stages {

        stage('Checkout') {
            steps {
                git url: 'https://github.com/rayenas/Rayen-Askri.git',
                    branch: 'main',
                    credentialsId: GIT_CREDENTIALS
            }
        }
stage('Build') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }

stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
    }

post {
        success {
            echo "Build DONE "
        }
        failure {
            echo "Build FAILED "
        }
    }
}

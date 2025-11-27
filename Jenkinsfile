pipeline {
agent any

environment {
GIT_CREDENTIALS = 'github-pat'
DOCKER_CREDS = 'docker-hub-creds'
DOCKER_IMAGE = 'rayen/student-management'
}

stages {

stage('Checkout') {
steps {
git url: 'https://github.com/rayenas/Rayen-Askri.git',
branch: 'main',
credentialsId: GIT_CREDENTIALS
}
}

stage('Build Maven') {
steps {
sh 'mvn -B -DskipTests clean package'
}
}

stage('Docker Build Image') {
steps {
script {
sh "docker build -t ${DOCKER_IMAGE}:latest ."
}
}
}

stage('Docker Login & Push') {
steps {
withCredentials([usernamePassword(credentialsId: DOCKER_CREDS,
usernameVariable: 'DOCKERHUB_USER',
passwordVariable: 'DOCKERHUB_PASS')]) {
sh "echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin"
sh "docker push ${DOCKER_IMAGE}:latest"
}
}
}
}

post {
success {
echo "Pipeline DONE ✔"
}
failure {
echo "Pipeline FAILED ❌"
}
}
}

pipeline {
agent any

environment {
DOCKER_HUB_REPO = "rayenaskri/student-management"
IMAGE_TAG = "latest"
}

stages {
       
stage('Build Maven Project') {
steps {
sh 'mvn clean package -DskipTests'
}
}

stage('Build Docker Image') {
steps {
sh 'docker build -t $DOCKER_HUB_REPO:$IMAGE_TAG .'
}
}

stage('Push Docker Image to Docker Hub') {
steps {
withCredentials([usernamePassword(
credentialsId: 'docker-hub-creds',
usernameVariable: 'DOCKER_USER',
passwordVariable: 'DOCKER_PASS'
)]) {
sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
sh 'docker push $DOCKER_HUB_REPO:$IMAGE_TAG'
}
}
}
}

post {
success {
echo "Build + Docker Push SUCCESS 🎉"
}
failure {
echo "Build FAILED "
}
}
}

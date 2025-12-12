pipeline {
agent any

environment {
GIT_CREDENTIALS = 'github-pat'
DOCKERHUB_CREDENTIALS = 'docker-hub-creds'
DOCKER_IMAGE = "rayenaskri/student-management"
K8S_NAMESPACE = "devops"
KUBECONFIG = '/var/lib/jenkins/.kube/config'
}

stages {

stage('Checkout') {
steps {
git url: 'https://github.com/rayenas/Rayen-Askri.git',
branch: 'main',
credentialsId: GIT_CREDENTIALS
}
}

stage('Maven Build') {
steps {
sh 'mvn -B -DskipTests clean package'
}
}

stage('Docker Build') {
steps {
sh 'docker build -t $DOCKER_IMAGE:latest .'
}
}

stage('Docker Push') {
steps {
withCredentials([usernamePassword(
credentialsId: DOCKERHUB_CREDENTIALS,
usernameVariable: 'DOCKERHUB_USER',
passwordVariable: 'DOCKERHUB_PASS'
)]) {
sh '''
echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
docker push $DOCKER_IMAGE:latest
'''
}
}
}

stage('Archive Artifact') {
steps {
archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
}
}

stage('Deploy to Kubernetes') {
steps {
sh 'kubectl apply -f ${WORKSPACE}/deployment.yaml -n $K8S_NAMESPACE'
}
}

}

post {
success { echo "✔ BUILD + DOCKER PUSH + K8S DEPLOY SUCCESSFUL" }
failure { echo "❌ PIPELINE FAILED" }
}
}

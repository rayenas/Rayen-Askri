pipeline {
agent any

environment {
GIT_CREDENTIALS = 'github-pat'
DOCKERHUB_CREDENTIALS = 'docker-hub-creds'
DOCKER_IMAGE = "rayenaskri/student-management"
KUBE_CREDENTIALS = "kubeconfig-cred"   // secret file
K8S_NAMESPACE = "devops"
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

/* ---------- FIXED KUBERNETES DEPLOY STAGE ---------- */
stage('Deploy to Kubernetes') {
steps {
withCredentials([file(credentialsId: KUBE_CREDENTIALS, variable: 'KCFG')]) {
    sh '''
        export KUBECONFIG=$KCFG

echo "📌 Using kubeconfig: $KUBECONFIG"

echo "📌 Deploying MySQL..."
kubectl apply -f k8s/mysql-secret.yaml -n devops || true
kubectl apply -f k8s/mysql-pv-pvc.yaml -n devops || true
kubectl apply -f k8s/mysql-deployment.yaml -n devops || true
kubectl apply -f k8s/mysql-service.yaml -n devops || true

echo "📌 Deploying Spring Boot..."
kubectl apply -f k8s/springboot-deployment.yaml -n devops
kubectl apply -f k8s/springboot-service.yaml -n devops

echo "🚀 Kubernetes deployment finished"
'''
}
}
}
        
}

post {
success { echo "✔ BUILD + DOCKER PUSH + K8S DEPLOY SUCCESSFUL" }
failure { echo "❌ PIPELINE FAILED" }
}
}

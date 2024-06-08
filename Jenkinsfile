pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "183991395055.dkr.ecr.us-east-1.amazonaws.com/goapp"
        ECR_LOGIN = 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 183991395055.dkr.ecr.us-east-1.amazonaws.com'
        KUBECONFIG_CREDENTIALS = credentials('kubeconfig-credential-id')
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                sh 'go build -o app main.go'
            }
        }
        stage('Test') {
            steps {
                sh 'go test ./...'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:latest .'
            }
        }
        stage('Push to ECR') {
            steps {
                sh script: ECR_LOGIN
                sh 'docker push $DOCKER_IMAGE:latest'
            }
        }
        stage('Deploy Canary') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig-credential-id', variable: 'KUBECONFIG')]) {
                    sh 'kubectl --kubeconfig=$KUBECONFIG apply -f k8s/deployment-canary.yaml'
                }
            }
        }
    }
}

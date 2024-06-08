pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "183991395055.dkr.ecr.us-east-1.amazonaws.com/goapp"
        ECR_LOGIN = 'aws ecr get-login-password --region your-region | docker login --username AWS --password-stdin 183991395055.dkr.ecr.us-east-1.amazonaws.com'
        // KUBECONFIG_CREDENTIALS = credentials('your-kubeconfig-credentials-id')
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
                withCredentials([file(credentialsId: 'your-kubeconfig-credentials-id', variable: 'KUBECONFIG')]) {
                    sh 'kubectl --kubeconfig=$KUBECONFIG apply -f k8s/deployment-canary.yaml'
                }
            }
        }
    }
}

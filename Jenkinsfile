pipeline {
    agent any

    stages {
        stage('Install Dependencies') {
            steps {
                sh 'yum install -y python3 python3-pip docker'
                sh 'pip3 install -r requirements.txt'
            }
        }

        stage('Train Model') {
            steps {
                sh 'python3 src/train.py'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t loan-risk-app .'
            }
        }

        stage('Run Container') {
            steps {
                sh 'docker run -d -p 8000:8000 loan-risk-app'
            }
        }
    }
}
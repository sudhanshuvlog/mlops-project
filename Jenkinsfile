pipeline {
     agent {label "ec2" }

    parameters {
        choice(
            name: 'SKIP_TRAINING',
            choices: ['false', 'true'],
            description: 'Skip training and reuse latest artifacts from S3'
        )
        string(
            name: 'MODEL_VERSION',
            defaultValue: '',
            description: 'Optional: specific model version timestamp to rollback to (e.g., 20260430-120000). Leave blank for latest.'
        )
        choice(
            name: 'PUSH_TO_S3',
            choices: ['true', 'false'],
            description: 'Push DVC artifacts (data/models) to S3 after training'
        )
    }

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        AWS_DEFAULT_REGION = 'ap-south-1'
        MLFLOW_TRACKING_URI = 'http://localhost:5000'  // or remote MLflow server
    }

    stages {
        stage('Install Dependencies') {
            steps {
                sh 'yum install -y python3 python3-pip docker git'
                sh 'pip3 install -r requirements.txt'
                sh 'dvc --version'  // verify DVC installed
                sh 'mlflow --version'  // verify MLflow installed
            }
        }

        stage('DVC Setup') {
            steps {
                sh '''
                    # Initialize DVC if not already done
                    if [ ! -d .dvc ]; then
                        dvc init -f --no-scm
                    fi
                    
                    # Ensure remote is configured
                    dvc remote list | grep -q myremote || dvc remote add -d myremote s3://mlops-loan-risk-gfg/dvc-storage
                    
                    # Fetch latest from remote (pulls data if needed)
                    dvc fetch || echo "Warning: dvc fetch failed (may be first run)"
                    dvc checkout || echo "Warning: dvc checkout failed"
                '''
            }
        }

        stage('Train Model with DVC Pipeline') {
            when {
                expression { params.SKIP_TRAINING == 'false' }
            }
            steps {
                sh '''
                    mkdir -p models
                    
                    # Run reproducible DVC pipeline (preprocess + train)
                    # DVC caches stages, so unchanged stages won't re-run
                    dvc repro
                    
                    # View pipeline DAG (for debugging)
                    dvc dag
                '''
            }
        }

        stage('Collect Metrics') {
            steps {
                sh '''
                    # Display DVC pipeline status (what changed)
                    echo "=== DVC Pipeline Status ==="
                    dvc status
                    
                    # If MLflow server is running, pull recent runs
                    echo "=== Recent MLflow Runs ==="
                    mlflow runs list --experiment-name "loan-risk-prediction" --max-results 5 || echo "MLflow not accessible (OK if server not running)"
                '''
            }
        }

        stage('Push Artifacts to S3 (DVC)') {
            when {
                expression { params.PUSH_TO_S3 == 'true' }
            }
            steps {
                sh '''
                    # Push models/data to S3 using DVC
                    echo "Pushing DVC artifacts to S3..."
                    dvc push
                    
                    # Verify push succeeded
                    if [ $? -eq 0 ]; then
                        echo "✓ DVC push to S3 completed successfully"
                        dvc status --cloud
                    else
                        echo "✗ DVC push failed"
                        exit 1
                    fi
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t loan-risk-app .'
            }
        }

        stage('Run Container') {
            steps {
                sh 'docker rm -f webapp || true'
                script {
                    def envVars = "-e AWS_ACCESS_KEY_ID=\$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=\$AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION=ap-south-1"
                    
                    if (params.MODEL_VERSION) {
                        envVars += " -e MODEL_VERSION=${params.MODEL_VERSION}"
                    }
                    
                    // Optional: pass MLflow tracking URI if needed
                    envVars += " -e MLFLOW_TRACKING_URI=\$MLFLOW_TRACKING_URI"
                    
                    sh "docker run -d --name webapp ${envVars} -p 8000:8000 loan-risk-app"
                }
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                    echo "Waiting for container to start..."
                    sleep 5
                    
                    # Test API endpoint
                    curl -f http://localhost:8000/ || (echo "API health check failed"; exit 1)
                    echo "✓ API is running"
                '''
            }
        }
    }

    post {
        always {
            // Collect artifacts for Jenkins archival
            sh 'mkdir -p artifacts'
            sh 'cp -r dvc.lock metrics.json models/ artifacts/ || echo "No artifacts to collect"'
            
            // Archive DVC lock file (shows reproducible pipeline state)
            archiveArtifacts artifacts: 'artifacts/dvc.lock', allowEmptyArchive: true
        }
        failure {
            echo "Pipeline failed. Check MLflow UI for experiment details."
            echo "Rollback command: set MODEL_VERSION to a previous timestamp"
        }
        success {
            echo "✓ Pipeline completed successfully!"
            echo "View metrics in MLflow: $MLFLOW_TRACKING_URI"
            echo "DVC artifacts pushed to S3 (if PUSH_TO_S3=true)"
        }
    }
}
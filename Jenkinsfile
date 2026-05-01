pipeline {
     agent {label "ec2" }

    // parameters {
    //     string(
    //         name: 'MODEL_VERSION',
    //         defaultValue: '',
    //         description: 'Optional: specific model version timestamp to rollback to (e.g., 20260430-120000). Leave blank for latest.'
    //     )
    //     choice(
    //         name: 'PUSH_TO_S3',
    //         choices: ['true', 'false'],
    //         description: 'Push DVC artifacts (data/models) to S3 after training'
    //     )
    // }

    environment {
        // AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
        // AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        AWS_DEFAULT_REGION = 'ap-south-1'
        MLFLOW_TRACKING_URI = 'http://localhost:5000'  // or remote MLflow server
    }

    stages {
        stage('Install Dependencies') {
            steps {
                sh '''
                    yum install -y python3 python3-pip docker git
                    
                    # Create virtual environment
                    python3 -m venv venv
                    
                    # Install in one go (venv path included)
                    ./venv/bin/pip install --upgrade pip setuptools wheel
                    ./venv/bin/pip install -r requirements.txt --no-cache-dir
                    ./venv/bin/pip install setuptools==69.5.1 wheel==0.42.0 packaging==24.0
                    # Verify
                    ./venv/bin/dvc --version
                    ./venv/bin/mlflow --version
                '''
            }
        }

        stage('DVC Setup') {
            steps {
                sh '''
                    # Initialize DVC if not already done
                    if [ ! -d .dvc ]; then
                        ./venv/bin/dvc init -f --no-scm
                    fi
                    
                    # Ensure remote is configured
                    ./venv/bin/dvc remote list | grep -q myremote || ./venv/bin/dvc remote add -d myremote s3://mlops-loan-risk-gfg/dvc-storage
                    
                    # Only fetch/checkout if dvc.lock exists (means pipeline has run before)
                    if [ -f dvc.lock ]; then
                        echo "dvc.lock found. Fetching artifacts from S3..."
                        ./venv/bin/dvc fetch || echo "Warning: dvc fetch failed"
                        ./venv/bin/dvc checkout --force || echo "Warning: dvc checkout failed"
                    else
                        echo "First run detected (no dvc.lock). Skipping fetch/checkout."
                    fi
                '''
            }
        }

        stage('start mlflow server') {
            steps {
                sh '''
                    nohup ./venv/bin/mlflow server \
                        --backend-store-uri sqlite:///mlflow.db \
                        --default-artifact-root ./mlruns \
                        --host 0.0.0.0 \
                        --port 5000 &
                '''
            }
        }

        stage('Train Model with DVC Pipeline') {
            steps {
                sh '''
                    mkdir -p models
                    
                    # Run reproducible DVC pipeline (preprocess + train)
                    # DVC caches stages, so unchanged stages won't re-run
                    ./venv/bin/dvc repro
                    
                    # View pipeline DAG (for debugging)
                    ./venv/bin/dvc dag
                '''
            }
        }

        stage('Collect Metrics') {
            steps {
                sh '''
                    # Display DVC pipeline status (what changed)
                    echo "=== DVC Pipeline Status ==="
                    ./venv/bin/dvc status
                    
                    # If MLflow server is running, pull recent runs
                    echo "=== Recent MLflow Runs ==="
                    ./venv/bin/mlflow runs list --experiment-name "loan-risk-prediction" --max-results 5 || echo "MLflow not accessible (OK if server not running)"
                '''
            }
        }

        stage('Push Artifacts to S3 (DVC)') {
            // when {
            //     expression { params.PUSH_TO_S3 == 'true' }
            // }
            steps {
                sh '''
                    # Push models/data to S3 using DVC
                    echo "Pushing DVC artifacts to S3..."
                    ./venv/bin/dvc push
                    
                    # Verify push succeeded
                    if [ $? -eq 0 ]; then
                        echo "✓ DVC push to S3 completed successfully"
                        ./venv/bin/dvc status --cloud
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
                    
                    // if (params.MODEL_VERSION) {
                    //     envVars += " -e MODEL_VERSION=${params.MODEL_VERSION}"
                    // }
                    
                    // Optional: pass MLflow tracking URI if needed
                    envVars += " -e MLFLOW_TRACKING_URI=\$MLFLOW_TRACKING_URI"
                    
                    sh "docker run -d --name webapp ${envVars} -p 8000:8000 loan-risk-app"
                }
            }
        }
    }

    // post {
    //     always {
    //         // Collect artifacts for Jenkins archival
    //         sh 'mkdir -p artifacts'
    //         sh 'cp -r dvc.lock metrics.json models/ artifacts/ || echo "No artifacts to collect"'
            
    //         // Archive DVC lock file (shows reproducible pipeline state)
    //         archiveArtifacts artifacts: 'artifacts/dvc.lock', allowEmptyArchive: true
    //     }
    //     failure {
    //         echo "Pipeline failed. Check MLflow UI for experiment details."
    //         echo "Rollback command: set MODEL_VERSION to a previous timestamp"
    //     }
    //     success {
    //         echo "✓ Pipeline completed successfully!"
    //         echo "View metrics in MLflow: $MLFLOW_TRACKING_URI"
    //         echo "DVC artifacts pushed to S3 (if PUSH_TO_S3=true)"
    //     }
    // }
}
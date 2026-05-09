# ML Model Deployment: Loan Risk Prediction

A complete MLOps pipeline for training, versioning, and deploying a machine learning model (XGBoost) with **DVC** for artifact versioning, **MLflow** for experiment tracking, and **Jenkins** for CI/CD automation.

## Architecture Overview

```
┌─────────────────────┐
│  Git Repository     │ (dvc.yaml, dvc.lock, code)
└──────────┬──────────┘
           │
      ┌────▼────┐
      │ Jenkins  │ (CI/CD Pipeline)
      └────┬────┘
           │
    ┌──────┴──────┬─────────────────┐
    │             │                 │
    ▼             ▼                 ▼
┌────────┐  ┌──────────┐  ┌─────────────────┐
│ Train  │→ │ DVC Push │→ │ AWS S3 Storage  │
│ Model  │  │ Artifacts│  │ (models, data)  │
└────────┘  └──────────┘  └────────┬────────┘
    │                              │
    ▼                              │
┌────────────┐                     │
│ MLflow     │                     │
│ Dashboard  │                     │
└────────────┘                     │
                                   │
                        ┌──────────▼────────────┐
                        │ Docker Container      │
                        │ (FastAPI + predict.py)│
                        │ - dvc pull from S3    │
                        │ - Load models         │
                        │ - Serve API           │
                        └──────────────────────┘
```

---

## Prerequisites

### Local Machine
- Python 3.9+
- Git
- AWS account with S3 access
- Docker (for local testing)

### AWS Setup
- **S3 Bucket**: `mlops-loan-risk-gfg`
- **IAM User** with S3 access (for credentials)
- **EC2 Instance** for Jenkins agent (t2.medium recommended)

### Jenkins Server
- Docker or standalone Jenkins
- JDK 21
- Docker installed on Jenkins agent

---

## Part 1: Local Development Setup

### Step 1: Clone and Create Virtual Environment

```bash
git clone <repo-url>
cd ml-model-deployment

# Create virtual environment
python3 -m venv venv

# Activate it
# On Linux/Mac:
source venv/bin/activate
# On Windows:
venv\Scripts\activate
```

### Step 2: Install Dependencies

```bash
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt
```

### Step 3: Configure AWS Credentials

```bash
# Set environment variables or use AWS CLI
aws configure

# Or set directly:
export AWS_ACCESS_KEY_ID=AKIA...
export AWS_SECRET_ACCESS_KEY=...
export AWS_DEFAULT_REGION=ap-south-1
```

### Step 4: Initialize DVC and Set Remote Storage

```bash
# Initialize DVC (one-time)
dvc init --no-scm

# Add S3 as remote storage
dvc remote add -d myremote s3://mlops-loan-risk-gfg/dvc-storage
```

### Step 5: Generate Training Data

```bash
python data-generator.py
# Creates: data/loan_data.csv
```

### Step 6: Run dvc repro

```bash
dvc repro
```

### Step 7: Push Artifacts to S3

```bash
dvc push

# Verify
dvc status --cloud
```

## Part 2: Jenkins CI/CD Pipeline Setup

### Prerequisites
- Jenkins server running (Docker or standalone)
- EC2 agent with Python 3.9+, Docker, Git
- AWS credentials stored in Jenkins

### Step 1: Add AWS Credentials to Jenkins

1. Go to Jenkins → **Manage Credentials** → **System** → **Global credentials**
2. Click **Add Credentials** → Kind: **Username with password**
   - Username: `aws_access_key_id` → Password: `AKIA...`
   - ID: `aws_access_key_id`
3. Repeat for `aws_secret_access_key`
4. Or use **AWS Credentials Plugin**

### Step 2: Create Jenkins Pipeline Job

1. Jenkins → **New Item** → **Pipeline**
2. Name: `loan-risk-pipeline`
3. Pipeline → Definition: **Pipeline script from SCM**
   - SCM: Git
   - Repository URL: `<your-repo-url>`
   - Branch: `*/main`
   - Script Path: `Jenkinsfile`
4. **Save**

### Step 3: Configure Build Triggers (Optional)

For auto-trigger on Git push:
- GitHub: Configure webhook to send to Jenkins
- Or: Poll SCM (`H/5 * * * *` every 5 min)

### Step 4: Run Pipeline

Click **Build** or **Build with Parameters** (if defined):
- `SKIP_TRAINING`: false (train) or true (reuse S3)
- `MODEL_VERSION`: leave blank for latest, or enter timestamp to rollback

### What Happens in Pipeline

```
1. Setup Environment    → Create venv, install deps
2. DVC Setup           → Initialize DVC, fetch from S3 (if dvc.lock exists)
3. Start MLflow Server → MLflow UI on port 5000
4. Train with DVC      → dvc repro (preprocess + train)
5. Collect Metrics     → Display dvc status, MLflow runs
6. Push to S3          → dvc push (upload artifacts)
7. Build Docker Image  → Create Docker image
8. Run Container       → Start API on port 8000
9. Health Check        → Verify API is responding
```

---

## Part 3: DVC & MLflow Workflow

### DVC: Data Versioning & Pipelines

**Track artifacts:**
```bash
# View pipeline
dvc dag

# Check status
dvc status

# Push to S3
dvc push

# Pull from S3 (on another machine)
dvc pull

# View history
git log --oneline  # shows dvc.lock changes
```

**Rollback to previous version:**
```bash
# 1. Find commit with desired dvc.lock
git log --oneline -- dvc.lock

# 2. Checkout that version
git checkout <commit-hash> -- dvc.lock

# 3. Sync DVC workspace
dvc checkout

# 4. Rebuild/redeploy
```

### MLflow: Experiment Tracking

**View experiments:**
```bash
# Local UI
nohup ./venv/bin/mlflow server \
 --backend-store-uri sqlite:///mlflow.db \
 --default-artifact-root ./mlruns \
 --host 0.0.0.0 \
 --port 5000 &
# Open: http://ec2-ip:5000
```

**Compare runs:**
- MLflow UI shows all training runs
- Compare metrics: accuracy, precision, recall, F1
- View hyperparameters used
- Track S3 paths of artifacts

**Register model:**
- In MLflow UI: Runs → Click run → Register Model
- Creates versioned model entry (for production serving)

---

## Part 4: Docker Deployment

### Local Testing

```bash
# Build image
docker build -t loan-risk-app .

# Run container
docker run -d \
  -e AWS_DEFAULT_REGION=ap-south-1 \
  -p 8000:8000 \
  --name webapp \
  loan-risk-app

# Test API
curl http://localhost:8000/
curl -X POST http://localhost:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"income": 50000, "loan_amount": 20000, "credit_score": 700}'

# View logs
docker logs -f webapp

# Stop
docker stop webapp
docker rm webapp
```

### Docker Image Details

- **Base**: Python 3.10-slim
- **Entrypoint**: `dvc pull` + start API
- **Port**: 8000
- **Environment**: AWS credentials (injected at runtime)

---

## Part 5: API Usage

### Prediction Endpoint

**Request:**
```bash
POST /predict
Content-Type: application/json

{
  "income": 50000,
  "loan_amount": 20000,
  "credit_score": 700
}
```

**Response:**
```json
{
  "risk": "low",
  "confidence": 0.95
}
```

### Health Check

```bash
GET /
# Response: {"message": "Loan Risk API Running"}
```

---

## Part 6: Model Training & Evaluation

### Training Pipeline (`dvc repro`)

1. **Preprocess** → loads `data/loan_data.csv`
   - Drop NaNs
   - Encode target variable (risk)
   - Scale features (StandardScaler)
   - Outputs: `models/scaler.pkl`, `models/label_encoder.pkl`

2. **Train** → trains XGBClassifier
   - Test/Train split: 80/20
   - Logs metrics to MLflow
   - Outputs: `models/model.pkl`
   - Min accuracy threshold: 0.8 (fails if below)

### Metrics Tracked

- **Accuracy**: overall correctness
- **Precision**: true positives / predicted positives
- **Recall**: true positives / actual positives
- **F1 Score**: harmonic mean of precision & recall

---

## Part 7: Artifact Management

### File Structure

```
ml-model-deployment/
├── models/
│   ├── model.pkl           (XGBoost model)
│   ├── scaler.pkl          (StandardScaler)
│   └── label_encoder.pkl   (LabelEncoder)
├── data/
│   └── loan_data.csv       (training data)
├── src/
│   ├── app.py              (FastAPI app)
│   ├── predict.py          (prediction logic)
│   ├── train.py            (training script)
│   └── preprocess.py       (preprocessing)
├── dvc.yaml                (pipeline definition)
├── dvc.lock                (reproducible state)
├── Jenkinsfile             (CI/CD pipeline)
└── Dockerfile              (container config)
```

---

## Part 8: Model Versioning & Rollback

### Version Tracking

- **Git**: tracks `dvc.lock` (reproducible state)
- **S3**: stores actual model files (via DVC)
- **MLflow**: logs all experiment runs

### Rollback to Previous Version

**Option 1: Via DVC Lock**
```bash
# View history
git log --oneline -- dvc.lock

# Checkout previous version
git checkout <commit-hash> -- dvc.lock

# Sync workspace
dvc checkout

# Redeploy
```

**Option 2: Via Jenkins Parameter**
```bash
# Set MODEL_VERSION parameter when running Jenkins
# e.g., MODEL_VERSION=20260430-150000

# Container will download that specific version
```

---

## Part 9: Common Commands

### Development
```bash
# Run training locally
dvc repro

# Start MLflow dashboard
mlflow ui --host 0.0.0.0 --port 5000

# Push to S3
dvc push

# Pull from S3
dvc pull

# View pipeline
dvc dag

# Test prediction
python -c "from src.predict import predict; print(predict([50000, 20000, 700]))"
```

### Docker
```bash
# Build image
docker build -t loan-risk-app .

# Run container
docker run -d -e AWS_ACCESS_KEY_ID=... -e AWS_SECRET_ACCESS_KEY=... -p 8000:8000 loan-risk-app

# Test API
curl -X POST http://localhost:8000/predict -H "Content-Type: application/json" -d '{"income": 50000, "loan_amount": 20000, "credit_score": 700}'

# View logs
docker logs -f webapp
```

### Jenkins
```bash
# View pipeline execution
Jenkins → <pipeline> → Build History

# Trigger new build
Jenkins → <pipeline> → Build Now (or Build with Parameters)

# View logs
Jenkins → Build → Console Output
```

---

## Part 10: Troubleshooting

### DVC Issues

**Error: `cannot import name '_DIR_MARK'`**
```bash
pip install --upgrade dvc[s3] pathspec
```

**Error: `dvc pull` fails**
```bash
# Verify AWS credentials
aws s3 ls s3://mlops-loan-risk-gfg/

# Check DVC remote
dvc remote list

# Reconfigure if needed
dvc remote remove myremote
dvc remote add -d myremote s3://mlops-loan-risk-gfg/dvc-storage
```

### MLflow Issues

**Error: `ModuleNotFoundError: No module named 'pkg_resources'`**
```bash
pip install --force-reinstall setuptools>=65.0
```

**MLflow UI not accessible**
```bash
# Check if server is running
ps aux | grep mlflow

# Start server
mlflow ui --host 0.0.0.0 --port 5000
```

### Jenkins Issues

**Error: `Cannot uninstall requests`**
```bash
# Use virtual environment in Jenkins
python3 -m venv venv
./venv/bin/pip install -r requirements.txt
```

**Docker: Models not found in container**
```bash
# Check if dvc pull is working in Dockerfile entrypoint
docker logs <container-id>

# Manually test
docker run -it loan-risk-app bash
./entrypoint.sh  # should pull models
```

### API Issues

**Error: `Connection refused` on `/predict`**
```bash
# Check if container is running
docker ps

# Check logs
docker logs webapp

# Verify port mapping
docker port webapp
```

**Error: Model files not found**
```bash
# Ensure dvc pull ran successfully
docker exec webapp ls -la models/

# Or rebuild image
docker build --no-cache -t loan-risk-app .
```

---

## Environment Variables

### AWS Credentials
```
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...
AWS_DEFAULT_REGION=ap-south-1
```

### MLflow
```
MLFLOW_TRACKING_URI=http://localhost:5000  # or remote server
```

### DVC
```
DVC_REMOTE=myremote
```

---

## Key Files

| File | Purpose |
|------|---------|
| `dvc.yaml` | Pipeline definition (preprocess, train stages) |
| `dvc.lock` | Reproducible state (artifact hashes) |
| `Jenkinsfile` | CI/CD pipeline steps |
| `Dockerfile` | Container configuration |
| `requirements.txt` | Python dependencies |
| `src/train.py` | Training script (MLflow logging) |
| `src/predict.py` | Prediction logic |
| `src/preprocess.py` | Data preprocessing |
| `src/app.py` | FastAPI application |

---

## Next Steps

1. **Local Testing**: Run `dvc repro` and `mlflow ui` locally
2. **AWS Setup**: Configure S3 bucket and IAM credentials
3. **Jenkins Setup**: Create pipeline job and configure agent
4. **Deploy**: Run Jenkins pipeline to train and deploy
5. **Monitor**: View MLflow dashboard for experiment tracking
6. **Iterate**: Make changes, commit, and re-run Jenkins

---

## References

- [DVC Documentation](https://dvc.org/doc)
- [MLflow Documentation](https://mlflow.org/docs)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Docker Documentation](https://docs.docker.com/)

---

## Support

For issues or questions:
1. Check **Troubleshooting** section above
2. Review Jenkins logs: `Jenkins → Build → Console Output`
3. Check container logs: `docker logs webapp`
4. Verify AWS credentials: `aws s3 ls s3://mlops-loan-risk-gfg/`

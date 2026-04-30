# MLOps Setup Guide: MLflow + DVC

## What Each Tool Does

### **MLflow**
- **Experiment Tracking**: Logs parameters, metrics, and artifacts for each model run
- **Model Registry**: Manages model versions and stages (Development → Staging → Production)
- **Dashboard UI**: Compare runs, search experiments, visualize metrics

### **DVC** 
- **Data Versioning**: Version control for large datasets and model files (like Git for data)
- **Pipeline Orchestration**: Define reproducible workflows (preprocess → train → evaluate)
- **Remote Storage**: Push/pull data from S3 without storing in Git
- **Caching**: Skip re-running unchanged pipeline stages

---

## Setup Instructions

### 1. **Initialize DVC** (one-time)
```bash
dvc init --no-scm  # if not already done
dvc remote add -d myremote s3://mlops-loan-risk-gfg/dvc-storage
```

### 2. **Start MLflow Tracking Server** (for dashboard)
```bash
mlflow ui --host 0.0.0.0 --port 5000
```
Then open: `http://localhost:5000`

### 3. **Run Training with DVC Pipeline**
```bash
dvc repro  # runs entire pipeline (preprocess + train)
```

Or run just training:
```bash
python src/train.py
```

### 4. **Push DVC Artifacts to S3**
```bash
dvc push  # uploads models & data to S3
```

### 5. **Pull Latest Artifacts** (on another machine)
```bash
dvc pull  # downloads from S3
```

---

## What Gets Tracked

### **MLflow Logs** (in each run)
- Hyperparameters (model type, learning rate, etc.)
- Metrics (accuracy, precision, recall, F1)
- Artifacts (model.pkl, plots)
- S3 paths for model/scaler/encoder
- Run ID and timestamp

### **DVC Tracks**
- Dependencies (data, code files)
- Outputs (model.pkl, scaler.pkl, label_encoder.pkl)
- Pipeline stages and execution order

---

## Example Workflow

### **First Run (Training)**
```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. Initialize DVC remote
dvc remote add -d myremote s3://mlops-loan-risk-gfg/dvc-storage

# 3. Start MLflow dashboard
mlflow ui &

# 4. Run pipeline
dvc repro

# 5. Push to S3
dvc push

# 6. View MLflow UI
# Open http://localhost:5000 to see experiment runs, metrics, model registry
```

### **Subsequent Runs (with changes)**
```bash
# If you modify data or code:
dvc repro  # only re-runs affected stages (caching)
dvc push

# View changes in MLflow UI
```

### **Rollback / Compare Versions**
```bash
# Check DVC history
dvc dag  # shows pipeline structure

# Revert to previous data/model version
git checkout <commit_hash>
dvc checkout

# Compare metrics across runs in MLflow UI
```

---

## Environment Variables for Docker

Set these when running in a container:

```bash
# AWS Credentials
-e AWS_ACCESS_KEY_ID=AKIA...
-e AWS_SECRET_ACCESS_KEY=...
-e AWS_DEFAULT_REGION=ap-south-1

# Optional: MLflow tracking server (if remote)
-e MLFLOW_TRACKING_URI=http://mlflow-server:5000

# Optional: Model version for rollback
-e MODEL_VERSION=20260430-120000
```

---

## Directory Structure After Setup

```
ml-model-deployment/
├── .dvc/
│   ├── config          # DVC remote storage config
│   ├── .gitignore      # exclude DVC cache from Git
│   └── cache/          # local DVC cache (gitignored)
├── dvc.yaml            # pipeline definition
├── dvc.lock            # pipeline lock file (from `dvc repro`)
├── mlruns/             # local MLflow runs (gitignored)
├── src/
│   ├── train.py        # now logs to MLflow
│   ├── predict.py
│   └── s3_utils.py
├── models/             # local model cache
│   ├── model.pkl
│   ├── scaler.pkl
│   └── label_encoder.pkl
└── requirements.txt    # includes mlflow + dvc
```

---

## Common DVC Commands

```bash
# Status: check what needs to be pushed/pulled
dvc status

# Visualize pipeline
dvc dag

# Run pipeline with specific stage
dvc repro -s train

# Force re-run (skip cache)
dvc repro --force

# View what changed
dvc diff

# Fetch from remote without pulling
dvc fetch
```

---

## Troubleshooting

**Q: MLflow UI is empty**
- Make sure MLflow server is running: `mlflow ui --host 0.0.0.0 --port 5000`
- Set `MLFLOW_TRACKING_URI` if using a remote server

**Q: DVC can't find S3 credentials**
- Set `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` env vars
- Or configure in `~/.aws/credentials`

**Q: "dvc repro" is slow**
- DVC caches outputs. Remove cache if needed: `dvc cache dir -v`

**Q: Can't push to S3**
- Check AWS permissions on bucket
- Verify S3 bucket name in `.dvc/config`


import pandas as pd
import joblib
import mlflow
import mlflow.xgboost
from xgboost import XGBClassifier
from preprocess import preprocess_data
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score

# Configure MLflow to use local backend or remote server
mlflow.set_tracking_uri("http://localhost:5000")  # Change if using a remote MLflow server
mlflow.set_experiment("loan-risk-prediction")

def train():
    df = pd.read_csv("data/loan_data.csv")
    X_train, X_test, y_train, y_test = preprocess_data(df)

    # Start MLflow run
    with mlflow.start_run():
        # Log hyperparameters
        params = {
            "model_type": "XGBClassifier",
            "use_label_encoder": False,
            "eval_metric": "logloss",
            "test_size": 0.2,
            "random_state": 42,
        }
        mlflow.log_params(params)

        # Train model
        model = XGBClassifier(use_label_encoder=False, eval_metric='logloss')
        model.fit(X_train, y_train)

        # Make predictions
        preds = model.predict(X_test)
        
        # Calculate metrics
        acc = accuracy_score(y_test, preds)
        precision = precision_score(y_test, preds, average='weighted')
        recall = recall_score(y_test, preds, average='weighted')
        f1 = f1_score(y_test, preds, average='weighted')

        print(f"Model Accuracy: {acc}, Precision: {precision}, Recall: {recall}, F1: {f1}")

        # Log metrics to MLflow
        mlflow.log_metrics({
            "accuracy": acc,
            "precision": precision,
            "recall": recall,
            "f1": f1,
        })

        # Save and log model locally
        joblib.dump(model, "models/model.pkl")
        mlflow.xgboost.log_model(model, "model")

        if acc < 0.8:
            raise Exception("Model accuracy below threshold!")
        
        # DVC will handle uploading to S3 (via dvc push in CI/CD)
        # Just save locally - DVC tracks and versions it
        print("✓ Model saved locally. DVC will version and push to S3.")

        # Register model in MLflow registry
        mlflow.register_model("runs:/{}/model".format(mlflow.active_run().info.run_id), "LoanRiskModel")
        print("Model registered in MLflow registry as 'LoanRiskModel'")

    import json

    metrics = {
        "accuracy": acc,
        "precision": precision,
        "recall": recall,
        "f1": f1
    }

    with open("metrics.json", "w") as f:
        json.dump(metrics, f)


if __name__ == "__main__":
    train()
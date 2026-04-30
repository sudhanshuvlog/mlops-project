import pandas as pd
import joblib
import mlflow
import mlflow.xgboost
from xgboost import XGBClassifier
from preprocess import preprocess_data
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score
from s3_utils import upload_model

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
        precision = precision_score(y_test, preds)
        recall = recall_score(y_test, preds)
        f1 = f1_score(y_test, preds)

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
        
        # Upload to S3
        s3_path = upload_model("models/model.pkl")
        print(f"Model stored at: {s3_path}")
        mlflow.log_param("s3_model_path", s3_path)

        # Also upload scaler and label encoder saved during preprocessing
        try:
            scaler_path = upload_model("models/scaler.pkl", model_name="scaler.pkl")
            print(f"Scaler stored at: {scaler_path}")
            mlflow.log_param("s3_scaler_path", scaler_path)
        except Exception as e:
            print(f"Warning: failed to upload scaler: {e}")

        try:
            le_path = upload_model("models/label_encoder.pkl", model_name="label_encoder.pkl")
            print(f"Label encoder stored at: {le_path}")
            mlflow.log_param("s3_label_encoder_path", le_path)
        except Exception as e:
            print(f"Warning: failed to upload label encoder: {e}")

        # Register model in MLflow registry
        mlflow.register_model("runs:/{}/model".format(mlflow.active_run().info.run_id), "LoanRiskModel")
        print("Model registered in MLflow registry as 'LoanRiskModel'")


if __name__ == "__main__":
    train()
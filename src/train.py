import pandas as pd
import joblib
from xgboost import XGBClassifier
from preprocess import preprocess_data
from sklearn.metrics import accuracy_score
from src.s3_utils import upload_model

def train():
    df = pd.read_csv("data/loan_data.csv")

    X_train, X_test, y_train, y_test = preprocess_data(df)

    model = XGBClassifier(use_label_encoder=False, eval_metric='logloss')
    model.fit(X_train, y_train)

    preds = model.predict(X_test)
    acc = accuracy_score(y_test, preds)

    print(f"Model Accuracy: {acc}")

    joblib.dump(model, "models/model.pkl")

    if acc < 0.8:
        raise Exception("Model accuracy below threshold!")
    
    # Upload to S3
    s3_path = upload_model("models/model.pkl")
    print(f"Model stored at: {s3_path}")

    # Also upload scaler and label encoder saved during preprocessing
    try:
        scaler_path = upload_model("models/scaler.pkl", model_name="scaler.pkl")
        print(f"Scaler stored at: {scaler_path}")
    except Exception as e:
        print(f"Warning: failed to upload scaler: {e}")

    try:
        le_path = upload_model("models/label_encoder.pkl", model_name="label_encoder.pkl")
        print(f"Label encoder stored at: {le_path}")
    except Exception as e:
        print(f"Warning: failed to upload label encoder: {e}")


if __name__ == "__main__":
    train()
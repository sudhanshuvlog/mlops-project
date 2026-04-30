import joblib
import numpy as np
import os
from src.s3_utils import download_latest_file, download_file_by_version

# Support rolling back to a specific version via MODEL_VERSION env var.
# If not set, uses the latest artifacts.
model_version = os.environ.get("MODEL_VERSION")

if model_version:
    print(f"Rolling back to model version: {model_version}")
    download_file_by_version("scaler.pkl", model_version, "models/scaler.pkl")
    download_file_by_version("label_encoder.pkl", model_version, "models/label_encoder.pkl")
    download_file_by_version("model.pkl", model_version, "models/model.pkl")
else:
    # Ensure we have latest model, scaler and label encoder from S3
    download_latest_file("scaler.pkl", "models/scaler.pkl")
    download_latest_file("label_encoder.pkl", "models/label_encoder.pkl")
    download_latest_file("model.pkl", "models/model.pkl")

scaler = joblib.load("models/scaler.pkl")
le = joblib.load("models/label_encoder.pkl")
model = joblib.load("models/model.pkl")


def predict(data):
    data = np.array(data).reshape(1, -1)
    data = scaler.transform(data)
    pred = model.predict(data)
    prob = float(model.predict_proba(data).max())

    return le.inverse_transform(pred)[0], prob
import joblib
import numpy as np
from src.s3_utils import download_latest_file

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
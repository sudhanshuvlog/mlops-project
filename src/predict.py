import joblib
import numpy as np
from s3_utils import download_latest_model

#model = joblib.load("models/model.pkl")
scaler = joblib.load("models/scaler.pkl")
#le = joblib.load("models/label_encoder.pkl")
model_path = download_latest_model()
model = joblib.load(model_path)

def predict(data):
    data = np.array(data).reshape(1, -1)
    data = scaler.transform(data)
    pred = model.predict(data)
    prob = model.predict_proba(data).max()

    return le.inverse_transform(pred)[0], float(prob)
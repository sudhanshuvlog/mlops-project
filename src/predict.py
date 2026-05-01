import joblib
import numpy as np
import os

# Models are already pulled by DVC in Jenkins (dvc fetch/checkout)
# Just load from local files
scaler = joblib.load("models/scaler.pkl")
le = joblib.load("models/label_encoder.pkl")
model = joblib.load("models/model.pkl")


def predict(data):
    data = np.array(data).reshape(1, -1)
    data = scaler.transform(data)
    pred = model.predict(data)
    prob = float(model.predict_proba(data).max())

    return le.inverse_transform(pred)[0], prob
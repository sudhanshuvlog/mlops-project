import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
import joblib


def preprocess_data(df):
    df = df.dropna()

    X = df.drop("risk", axis=1)
    from sklearn.preprocessing import LabelEncoder

    y = df["risk"]

    le = LabelEncoder()
    y = le.fit_transform(y)

    joblib.dump(le, "models/label_encoder.pkl")

    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)

    joblib.dump(scaler, "models/scaler.pkl")

    return train_test_split(X_scaled, y, test_size=0.2, random_state=42)
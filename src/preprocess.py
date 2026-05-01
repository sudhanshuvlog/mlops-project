"""Preprocessing utilities for model training."""
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, LabelEncoder
import joblib
import os


def preprocess_data(df: pd.DataFrame, models_dir: str = "models"):
    """
    Preprocess data for model training.
    
    Args:
        df: DataFrame with features and 'risk' target column
        models_dir: Directory to save preprocessing artifacts
        
    Returns:
        X_train, X_test, y_train, y_test
    """
    os.makedirs(models_dir, exist_ok=True)
    
    # Drop rows with missing values
    df = df.dropna()
    
    # Separate features and target
    if "risk" not in df.columns:
        raise ValueError("'risk' column not found in data!")
    
    y = df["risk"]
    X = df.drop(columns=["risk"])
    
    # Remove non-numeric columns that shouldn't be features
    # Keep only numeric columns for the model
    numeric_cols = X.select_dtypes(include=['int64', 'float64', 'uint8']).columns
    X = X[numeric_cols]
    
    print(f"   Features used: {list(X.columns)}")
    
    # Encode target labels
    le = LabelEncoder()
    y_encoded = le.fit_transform(y)
    joblib.dump(le, os.path.join(models_dir, "label_encoder.pkl"))
    print(f"   Label classes: {list(le.classes_)}")
    
    # Scale features
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)
    joblib.dump(scaler, os.path.join(models_dir, "scaler.pkl"))
    
    # Also save feature names for prediction
    joblib.dump(list(X.columns), os.path.join(models_dir, "feature_names.pkl"))
    
    return train_test_split(X_scaled, y_encoded, test_size=0.2, random_state=42)
import pandas as pd
import joblib
from xgboost import XGBClassifier
from preprocess import preprocess_data
from sklearn.metrics import accuracy_score
from s3_utils import upload_model

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


if __name__ == "__main__":
    train()
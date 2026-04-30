import boto3
import os
from datetime import datetime

s3 = boto3.client("s3")

BUCKET_NAME = "mlops-loan-risk-gfg"


def upload_model(file_path, model_name="model.pkl"):
    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    version_path = f"models/{timestamp}/{model_name}"

    s3.upload_file(file_path, BUCKET_NAME, version_path)

    print(f"Uploaded to S3: {version_path}")
    return version_path

def download_latest_model(local_path="models/latest_model.pkl"):
    response = s3.list_objects_v2(Bucket=BUCKET_NAME, Prefix="models/")

    all_files = [obj["Key"] for obj in response.get("Contents", []) if obj["Key"].endswith(".pkl")]

    latest = sorted(all_files)[-1]

    s3.download_file(BUCKET_NAME, latest, local_path)

    print(f"Downloaded: {latest}")
    return local_path
import boto3
import os
from datetime import datetime

AWS_ACCESS_KEY = os.getenv("AWS_ACCESS_KEY_ID")
AWS_SECRET_KEY = os.getenv("AWS_SECRET_ACCESS_KEY")
AWS_REGION = "ap-south-1"

BUCKET_NAME = "mlops-loan-risk-gfg"

s3 = boto3.client(
    "s3",
    aws_access_key_id=AWS_ACCESS_KEY,
    aws_secret_access_key=AWS_SECRET_KEY,
    region_name=AWS_REGION
)

def upload_model(file_path, model_name="model.pkl"):
    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    version_path = f"models/{timestamp}/{model_name}"

    s3.upload_file(file_path, BUCKET_NAME, version_path)

    print(f"Uploaded to S3: {version_path}")
    return version_path

def download_latest_model(local_path="models/latest_model.pkl"):
    # Download the latest model.pkl by name
    return download_latest_file("model.pkl", local_path)


def download_latest_file(file_name, local_path):
    """Download the latest file with name `file_name` under the models/ prefix.

    Example: download_latest_file('scaler.pkl', 'models/scaler.pkl')
    """
    response = s3.list_objects_v2(Bucket=BUCKET_NAME, Prefix="models/")

    contents = response.get("Contents", [])
    all_files = [obj["Key"] for obj in contents if obj["Key"].endswith(file_name)]

    if not all_files:
        raise FileNotFoundError(f"No files named {file_name} found in S3 bucket {BUCKET_NAME} under 'models/'.")

    latest = sorted(all_files)[-1]

    # ensure local directory exists
    local_dir = os.path.dirname(local_path)
    if local_dir and not os.path.exists(local_dir):
        os.makedirs(local_dir, exist_ok=True)

    s3.download_file(BUCKET_NAME, latest, local_path)

    print(f"Downloaded: {latest}")
    return local_path
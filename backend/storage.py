import boto3
from botocore.config import Config
from backend.config import settings

def get_s3_client():
    return boto3.client(
        's3',
        endpoint_url=settings.s3_endpoint_url,
        aws_access_key_id=settings.s3_access_key,
        aws_secret_access_key=settings.s3_secret_key,
        region_name=settings.s3_region,
        config=Config(signature_version='s3v4')
    )

def generate_presigned_url(client_method, method_parameters, expires_in=3600):
    s3_client = get_s3_client()
    try:
        response = s3_client.generate_presigned_url(
            ClientMethod=client_method,
            Params=method_parameters,
            ExpiresIn=expires_in
        )
    except Exception as e:
        print(f"Error generating presigned URL: {e}")
        return None
    return response

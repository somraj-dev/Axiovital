import boto3
import os
from botocore.exceptions import ClientError
from backend.config import settings

class S3CacheService:
    _s3_client = None

    @classmethod
    def get_client(cls):
        if cls._s3_client is None:
            cls._s3_client = boto3.client(
                's3',
                endpoint_url=settings.s3_endpoint_url if "localhost" in settings.s3_endpoint_url else None,
                aws_access_key_id=settings.s3_access_key,
                aws_secret_access_key=settings.s3_secret_key,
                region_name=settings.s3_region
            )
        return cls._s3_client

    @classmethod
    async def cache_file(cls, cid: str, encrypted_bytes: bytes) -> str:
        """
        Uploads encrypted medical record to AWS S3.
        Cost-effective storage (approx $0.10/GB) as requested.
        """
        s3 = cls.get_client()
        try:
            s3.put_object(
                Bucket=settings.s3_bucket_name,
                Key=cid,
                Body=encrypted_bytes,
                ContentType='application/octet-stream'
            )
            return f"s3://{settings.s3_bucket_name}/{cid}"
        except ClientError as e:
            print(f"S3 Upload Error: {e}")
            # Fallback to local if S3 fails or is not configured
            os.makedirs("uploads", exist_ok=True)
            path = os.path.join("uploads", cid)
            with open(path, "wb") as f:
                f.write(encrypted_bytes)
            return path

    @classmethod
    async def get_cached(cls, cid: str) -> bytes:
        """Retrieves encrypted file from S3."""
        s3 = cls.get_client()
        try:
            response = s3.get_object(Bucket=settings.s3_bucket_name, Key=cid)
            return response['Body'].read()
        except ClientError:
            # Check local fallback
            path = os.path.join("uploads", cid)
            if os.path.exists(path):
                with open(path, "rb") as f:
                    return f.read()
            return None

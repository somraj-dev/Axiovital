from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    # Database
    postgres_user: str = "postgres"
    postgres_password: str = "postgres"
    postgres_db: str = "axiovital"
    database_url: str = "sqlite+aiosqlite:///./test.db" # Default for local dev/testing if no env var

    # Redis
    redis_url: str = "redis://localhost:6379/0"

    # S3
    s3_endpoint_url: str = "http://localhost:9000"
    s3_access_key: str = "DUMMY"
    s3_secret_key: str = "DUMMY"
    s3_bucket_name: str = "axiovital-bucket"
    s3_region: str = "us-east-1"

    # AI Service
    ai_service_url: str = "http://localhost:8001"

    # Security
    secret_key: str = "secret"
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30

    model_config = SettingsConfigDict(env_file=".env", env_file_encoding='utf-8', extra='ignore')

settings = Settings()

from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    ai_model_path: str = "./models/dummy.bin"
    ai_service_port: int = 8001
    
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding='utf-8', extra='ignore')

settings = Settings()

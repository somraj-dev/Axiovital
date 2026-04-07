import os

class S3CacheService:
    CACHE_DIR = "uploads"

    @staticmethod
    async def cache_file(cid: str, encrypted_bytes: bytes) -> str:
        """Mock S3 caching using local filesystem"""
        if not os.path.exists(S3CacheService.CACHE_DIR):
            os.makedirs(S3CacheService.CACHE_DIR)
        path = os.path.join(S3CacheService.CACHE_DIR, cid)
        with open(path, "wb") as f:
            f.write(encrypted_bytes)
        return path
    
    @staticmethod
    async def get_cached(cid: str) -> bytes:
        """Retrieve from mock cache"""
        path = os.path.join(S3CacheService.CACHE_DIR, cid)
        if os.path.exists(path):
            with open(path, "rb") as f:
                return f.read()
        return None

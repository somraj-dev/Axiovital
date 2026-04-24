import httpx
import os
import hashlib
from backend.config import settings

class IPFSService:
    PINATA_API_URL = "https://api.pinata.cloud/pinning/pinFileToIPFS"
    
    @classmethod
    async def upload_file(cls, file_bytes: bytes, filename: str, metadata: dict = None) -> str:
        """
        Uploads file to IPFS via Pinata. 
        Requires PINATA_API_KEY and PINATA_SECRET_API_KEY in environment.
        """
        api_key = os.getenv("PINATA_API_KEY")
        secret_key = os.getenv("PINATA_SECRET_API_KEY")
        
        if not api_key or not secret_key:
            # Fallback to local mock hash if keys are missing, but log a warning
            print("WARNING: Pinata API keys missing. Using local hash for CID.")
            return "Qm" + hashlib.sha256(file_bytes).hexdigest()[:44]

        headers = {
            "pinata_api_key": api_key,
            "pinata_secret_api_key": secret_key
        }
        
        files = {
            'file': (filename, file_bytes)
        }
        
        async with httpx.AsyncClient() as client:
            response = await client.post(cls.PINATA_API_URL, files=files, headers=headers)
            if response.status_code == 200:
                return response.json()["IpfsHash"]
            else:
                raise Exception(f"IPFS Upload failed: {response.text}")
    
    @staticmethod
    async def get_file(cid: str) -> bytes:
        """Retrieves file from IPFS gateway."""
        async with httpx.AsyncClient() as client:
            response = await client.get(f"https://gateway.pinata.cloud/ipfs/{cid}")
            if response.status_code == 200:
                return response.content
            else:
                raise Exception(f"Failed to retrieve file from IPFS: {response.text}")
    
    @staticmethod
    def get_gateway_url(cid: str) -> str:
        return f"https://gateway.pinata.cloud/ipfs/{cid}"

class IPFSService:
    @staticmethod
    async def upload_file(file_bytes: bytes, filename: str, metadata: dict = None) -> str:
        """Mock upload file to IPFS via Pinata, return dummy CID"""
        import hashlib
        # Fake a hash CID
        cid = "Qm" + hashlib.sha256(file_bytes).hexdigest()[:44]
        return cid
    
    @staticmethod
    async def get_file(cid: str) -> bytes:
        """Mock retrieve file from IPFS"""
        return b"Mock file content"
    
    @staticmethod
    def get_gateway_url(cid: str) -> str:
        return f"https://gateway.pinata.cloud/ipfs/{cid}"

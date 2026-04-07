import hashlib
import time

class BlockchainService:
    @staticmethod
    async def add_record(patient_addr: str, ipfs_cid: str, file_type: str, metadata: dict) -> dict:
        """Mock store record on Polygon"""
        tx_hash = "0x" + hashlib.sha256(str(time.time()).encode()).hexdigest()
        return {"tx_hash": tx_hash, "record_id": int(time.time())}
    
    @staticmethod
    async def grant_access(patient_addr: str, doctor_addr: str, record_id: int, duration_hours: int) -> str:
        """Mock grant access"""
        return "0x" + hashlib.sha256(str(time.time()).encode()).hexdigest()
    
    @staticmethod
    async def revoke_access(patient_addr: str, doctor_addr: str, record_id: int) -> str:
        """Mock revoke access"""
        return "0x" + hashlib.sha256(str(time.time()).encode()).hexdigest()
    
    @staticmethod
    async def verify_integrity(record_id: int, provided_cid: str) -> bool:
        """Mock verification"""
        return True

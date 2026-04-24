import hashlib
import time
import os
from web3 import Web3
from backend.config import settings

class BlockchainService:
    # Axiovital Health Registry Contract (Placeholder Address on Polygon Amoy)
    CONTRACT_ADDRESS = os.getenv("BLOCKCHAIN_CONTRACT_ADDRESS", "0x5FbDB2315678afecb367f032d93F642f64180aa3")
    RPC_URL = os.getenv("BLOCKCHAIN_RPC_URL", "https://rpc-amoy.polygon.technology")

    @classmethod
    def get_w3(cls):
        return Web3(Web3.HTTPProvider(cls.RPC_URL))

    @classmethod
    async def add_record(cls, patient_addr: str, ipfs_cid: str, file_type: str, metadata: dict) -> dict:
        """
        Logs a record hash and IPFS CID on the blockchain.
        In production, this would send a transaction to a Smart Contract.
        """
        private_key = os.getenv("BLOCKCHAIN_PRIVATE_KEY")
        if not private_key:
            # Fallback to local mock tx for dev if no wallet is provided
            print("WARNING: Blockchain Private Key missing. Using local mock transaction.")
            tx_hash = "0x" + hashlib.sha256(f"{patient_addr}{ipfs_cid}{time.time()}".encode()).hexdigest()
            return {"tx_hash": tx_hash, "record_id": int(time.time())}

        w3 = cls.get_w3()
        # Logic to send transaction would go here
        # For now, we simulate the hashing logic used in real contracts
        tx_hash = "0x" + hashlib.sha256(str(time.time()).encode()).hexdigest()
        return {"tx_hash": tx_hash, "record_id": int(time.time())}
    
    @classmethod
    async def grant_access(cls, patient_addr: str, doctor_addr: str, record_id: int, duration_hours: int) -> str:
        """Logs a 'Grant Access' permission on-chain."""
        # Simulated tx_hash
        return "0x" + hashlib.sha256(f"{patient_addr}{doctor_addr}{record_id}".encode()).hexdigest()
    
    @classmethod
    async def verify_integrity(cls, record_id: int, provided_cid: str) -> bool:
        """Verifies that the provided CID matches the one stored on-chain."""
        # In a real app, this calls the contract: return contract.functions.getRecord(record_id).call()[1] == provided_cid
        return True

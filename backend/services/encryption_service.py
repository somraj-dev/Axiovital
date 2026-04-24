import os
from cryptography.fernet import Fernet
from backend.config import settings

class EncryptionService:
    _fernet = None

    @classmethod
    def get_fernet(cls):
        if cls._fernet is None:
            # Use the secret key from settings to derive a valid 32-byte key for Fernet
            import base64
            from cryptography.hazmat.primitives import hashes
            from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
            
            salt = b'axiovital_salt_123' # In production, use a secure salt from env
            kdf = PBKDF2HMAC(
                algorithm=hashes.SHA256(),
                length=32,
                salt=salt,
                iterations=100000,
            )
            key = base64.urlsafe_b64encode(kdf.derive(settings.secret_key.encode()))
            cls._fernet = Fernet(key)
        return cls._fernet

    @classmethod
    def encrypt_file(cls, file_bytes: bytes) -> bytes:
        """Encrypts file bytes using AES-128 (Fernet)."""
        return cls.get_fernet().encrypt(file_bytes)
    
    @classmethod
    def decrypt_file(cls, ciphertext: bytes) -> bytes:
        """Decrypts ciphertext using AES-128 (Fernet)."""
        return cls.get_fernet().decrypt(ciphertext)

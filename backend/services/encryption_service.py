# Mock encryption for dev
class EncryptionService:
    @staticmethod
    def encrypt_file(file_bytes: bytes) -> bytes:
        # Mock encryption (just return same bytes in dev)
        return file_bytes
    
    @staticmethod
    def decrypt_file(ciphertext: bytes) -> bytes:
        # Mock decryption
        return ciphertext

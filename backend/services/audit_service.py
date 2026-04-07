from sqlalchemy.ext.asyncio import AsyncSession
from backend.models import AuditLog

class AuditService:
    @staticmethod
    async def log_action(db: AsyncSession, user_id: str, action: str, record_id: int = None, ip: str = None, device: str = None, tx_hash: str = None):
        """Append-only audit log"""
        log = AuditLog(
            user_id=user_id,
            action=action,
            record_id=record_id,
            ip_address=ip,
            device_info=device,
            tx_hash=tx_hash
        )
        db.add(log)
        await db.commit()

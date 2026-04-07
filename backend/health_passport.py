import os
from datetime import datetime, timedelta
from typing import List, Optional
import hashlib

from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form, Request
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from pydantic import BaseModel

from backend.database import get_db
from backend.models import (
    User, MedicalRecord, RecordFile, AccessRequest, AccessPermission, 
    AuditLog, EmergencyProfile, DoctorProfile
)
from backend.auth import get_current_user
from backend.services.ipfs_service import IPFSService
from backend.services.blockchain_service import BlockchainService
from backend.services.s3_cache_service import S3CacheService
from backend.services.encryption_service import EncryptionService
from backend.services.audit_service import AuditService

router = APIRouter(prefix="/api/v1/passport", tags=["Health Passport"])

# Pydantic Schemas
class MedicalRecordResponse(BaseModel):
    id: int
    title: str
    record_type: str
    hospital_name: Optional[str] = None
    doctor_name: Optional[str] = None
    created_at: datetime
    version: int
    is_active: bool
    ipfs_cid: Optional[str] = None
    hash_sha256: Optional[str] = None

    class Config:
        from_attributes = True

class EmergencyProfileUpdate(BaseModel):
    blood_group: str
    allergies: Optional[str] = None
    current_medications: Optional[str] = None
    critical_conditions: Optional[str] = None
    emergency_contact_name: Optional[str] = None
    emergency_contact_phone: Optional[str] = None
    is_public: bool = True

class AccessRequestResponse(BaseModel):
    id: int
    doctor_id: str
    record_id: int
    status: str
    requested_at: datetime
    expires_in_hours: int

    class Config:
        from_attributes = True

# --- EXCEPTION HANDLING --- #

# --- Endpoints --- #

@router.post("/upload")
async def upload_record(
    title: str = Form(...),
    record_type: str = Form(...),
    hospital_name: str = Form(None),
    doctor_name: str = Form(None),
    file: UploadFile = File(...),
    db: AsyncSession = Depends(get_db),
    current_user: dict = Depends(get_current_user) # e.g. {"uid": "VS-99283"}
):
    user_id = current_user.get("uid")

    file_bytes = await file.read()
    
    # Encrypt
    encrypted_bytes = EncryptionService.encrypt_file(file_bytes)
    
    # Hash
    file_hash = hashlib.sha256(encrypted_bytes).hexdigest()

    # Upload IPFS
    ipfs_cid = await IPFSService.upload_file(encrypted_bytes, file.filename)

    # Local S3 Mock Cache
    s3_key = await S3CacheService.cache_file(ipfs_cid, encrypted_bytes)

    # Blockchain
    bc_result = await BlockchainService.add_record(
        user_id, ipfs_cid, record_type, {"title": title}
    )
    tx_hash = bc_result["tx_hash"]

    # DB MedicalRecord
    record = MedicalRecord(
        patient_id=user_id,
        record_type=record_type,
        title=title,
        hospital_name=hospital_name,
        doctor_name=doctor_name
    )
    db.add(record)
    await db.flush() # get id

    # DB File
    record_file = RecordFile(
        record_id=record.id,
        ipfs_cid=ipfs_cid,
        s3_key=s3_key,
        hash_sha256=file_hash,
        file_size=len(encrypted_bytes),
        mime_type=file.content_type
    )
    db.add(record_file)
    await db.flush()

    # Audit
    await AuditService.log_action(db, user_id, "UPLOAD", record.id, tx_hash=tx_hash)
    await db.commit()

    return {"status": "success", "record_id": record.id, "ipfs_cid": ipfs_cid, "tx_hash": tx_hash}

@router.get("/records/{user_id}", response_model=List[MedicalRecordResponse])
async def get_records(user_id: str, db: AsyncSession = Depends(get_db)):
    # Join with file to get cid/hash
    query = select(MedicalRecord, RecordFile).outerjoin(RecordFile, MedicalRecord.id == RecordFile.record_id).where(MedicalRecord.patient_id == user_id, MedicalRecord.is_active == True).order_by(MedicalRecord.created_at.desc())
    result = await db.execute(query)
    
    records = []
    for rec, f in result.all():
        data = {
            "id": rec.id,
            "title": rec.title,
            "record_type": rec.record_type,
            "hospital_name": rec.hospital_name,
            "doctor_name": rec.doctor_name,
            "created_at": rec.created_at,
            "version": rec.version,
            "is_active": rec.is_active,
            "ipfs_cid": f.ipfs_cid if f else None,
            "hash_sha256": f.hash_sha256 if f else None,
        }
        records.append(MedicalRecordResponse(**data))
        
    return records

@router.get("/emergency/{user_id}")
async def get_emergency_profile(user_id: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(EmergencyProfile).where(EmergencyProfile.user_id == user_id))
    profile = result.scalar_one_or_none()
    if not profile:
        profile = EmergencyProfile(
            user_id=user_id,
            blood_group="Unknown",
            allergies="None known",
            current_medications="None",
            critical_conditions="None"
        )
        db.add(profile)
        await db.commit()
        await db.refresh(profile)
    return profile

@router.put("/emergency/{user_id}")
async def update_emergency_profile(user_id: str, data: EmergencyProfileUpdate, db: AsyncSession = Depends(get_db), current_user: dict = Depends(get_current_user)):
    if user_id != current_user.get('uid'):
        raise HTTPException(status_code=403, detail="Not authorized")
        
    result = await db.execute(select(EmergencyProfile).where(EmergencyProfile.user_id == user_id))
    profile = result.scalar_one_or_none()
    
    if not profile:
        profile = EmergencyProfile(user_id=user_id, **data.model_dump())
        db.add(profile)
    else:
        for k, v in data.model_dump().items():
            setattr(profile, k, v)
            
    await db.commit()
    await AuditService.log_action(db, user_id, "UPDATE_EMERGENCY")
    return profile

@router.get("/audit/{user_id}")
async def get_audit_trail(user_id: str, db: AsyncSession = Depends(get_db)):
    query = select(AuditLog).where(AuditLog.user_id == user_id).order_by(AuditLog.timestamp.desc())
    result = await db.execute(query)
    logs = []
    for log in result.scalars().all():
        logs.append({
            "id": log.id,
            "action": log.action,
            "record_id": log.record_id,
            "timestamp": log.timestamp,
            "tx_hash": log.tx_hash
        })
    return logs

@router.post("/access/request")
async def request_access(record_id: int, db: AsyncSession = Depends(get_db), current_user: dict = Depends(get_current_user)):
    doctor_id = current_user.get("uid")
    # Verify record exists
    result = await db.execute(select(MedicalRecord).where(MedicalRecord.id == record_id))
    record = result.scalar_one_or_none()
    if not record:
        raise HTTPException(status_code=404, detail="Record not found")
        
    req = AccessRequest(
        doctor_id=doctor_id,
        patient_id=record.patient_id,
        record_id=record_id,
        status="pending"
    )
    db.add(req)
    await db.commit()
    return {"status": "success", "request_id": req.id}

@router.get("/access/pending/{user_id}")
async def get_pending_requests(user_id: str, db: AsyncSession = Depends(get_db)):
    query = select(AccessRequest).where(AccessRequest.patient_id == user_id, AccessRequest.status == "pending")
    result = await db.execute(query)
    return result.scalars().all()

@router.put("/access/{request_id}/approve")
async def approve_request(request_id: int, db: AsyncSession = Depends(get_db), current_user: dict = Depends(get_current_user)):
    query = select(AccessRequest).where(AccessRequest.id == request_id)
    result = await db.execute(query)
    req = result.scalar_one_or_none()
    if not req or req.patient_id != current_user.get("uid"):
        raise HTTPException(status_code=404, detail="Request not found or unauthorized")
        
    req.status = "approved"
    
    # Blockchain
    tx_hash = await BlockchainService.grant_access(req.patient_id, req.doctor_id, req.record_id, req.expires_in_hours)
    
    # Permission DB
    perm = AccessPermission(
        doctor_id=req.doctor_id,
        patient_id=req.patient_id,
        record_id=req.record_id,
        expires_at=datetime.utcnow() + timedelta(hours=req.expires_in_hours),
        tx_hash=tx_hash
    )
    db.add(perm)
    await AuditService.log_action(db, req.patient_id, "GRANT_ACCESS", req.record_id, tx_hash=tx_hash)
    await db.commit()
    return {"status": "success", "tx_hash": tx_hash}

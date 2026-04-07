from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey, Boolean, Text
from sqlalchemy.orm import relationship
from datetime import datetime
from backend.database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(String, primary_key=True, index=True) # VS-99283 etc
    name = Column(String)
    email = Column(String, unique=True, index=True)
    avatar_url = Column(String, nullable=True)
    age = Column(String, nullable=True)
    weight = Column(String, nullable=True)
    blood_group = Column(String, nullable=True)
    dob = Column(String, nullable=True)
    phone = Column(String, nullable=True)
    address = Column(String, nullable=True)
    height = Column(String, nullable=True)
    gender = Column(String, nullable=True)
    
    # Settings/Membership
    membership_type = Column(String, default="PREMIUM MEMBER")
    member_since = Column(String, default="Oct 2023")
    is_two_factor_enabled = Column(Boolean, default=True)
    digital_twin_status = Column(String, default="Active")
    wearable_status = Column(String, default="CONNECTED")
    
    vitals = relationship("Vitals", back_populates="owner")
    medical_records = relationship("MedicalHistoryForm", back_populates="owner")
    conditions = relationship("Condition", back_populates="owner")
    location_history = relationship("LocationRecord", back_populates="owner")
    
    # Decentralized Health Passport
    health_records = relationship("MedicalRecord", back_populates="patient", foreign_keys="[MedicalRecord.patient_id]")
    emergency_profile = relationship("EmergencyProfile", back_populates="user", uselist=False)
    audit_logs = relationship("AuditLog", back_populates="user")
    doctor_profile = relationship("DoctorProfile", back_populates="user", uselist=False)

class Vitals(Base):
    __tablename__ = "vitals"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("users.id"))
    heart_rate = Column(Integer, nullable=True)
    systolic_bp = Column(Integer, nullable=True)
    diastolic_bp = Column(Integer, nullable=True)
    spo2 = Column(Integer, nullable=True)
    glucose = Column(Integer, nullable=True)
    timestamp = Column(DateTime, default=datetime.utcnow)

    owner = relationship("User", back_populates="vitals")

class Condition(Base):
    __tablename__ = "conditions"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("users.id"))
    title = Column(String) # e.g. Hypertension
    subtitle = Column(String, nullable=True) # e.g. Diagnosed Feb 2022
    icon_type = Column(String, default="default")
    is_active = Column(Boolean, default=True)
    timestamp = Column(DateTime, default=datetime.utcnow)

    owner = relationship("User", back_populates="conditions")

class MedicalHistoryForm(Base):
    __tablename__ = "medical_history_forms"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("users.id"))
    
    # Personal Info (most from User but form has specific fields)
    date = Column(DateTime, default=datetime.utcnow)
    phone = Column(String, nullable=True)
    dob = Column(String, nullable=True)
    age = Column(Integer, nullable=True)
    height = Column(String, nullable=True)
    weight = Column(String, nullable=True)
    emergency_contact = Column(String, nullable=True)
    emergency_relationship = Column(String, nullable=True)
    address = Column(Text, nullable=True)
    emergency_phone = Column(String, nullable=True)
    
    # Physician Info
    physician_name = Column(String, nullable=True)
    physician_specialty = Column(String, nullable=True)
    physician_address = Column(Text, nullable=True)
    physician_phone = Column(String, nullable=True)
    
    # Health Questions
    under_doctor_care = Column(Boolean, default=False)
    doctor_care_explanation = Column(Text, nullable=True)
    last_physical_exam = Column(String, nullable=True)
    
    had_exercise_test = Column(String, nullable=True) # Yes, No, Don't Know
    exercise_test_results = Column(String, nullable=True) # Normal, Abnormal
    
    takes_medications = Column(Boolean, default=False)
    medications_list = Column(Text, nullable=True)
    
    recently_hospitalized = Column(Boolean, default=False)
    hospitalization_explanation = Column(Text, nullable=True)
    
    # Lifestyle
    smokes = Column(Boolean, default=False)
    is_pregnant = Column(Boolean, default=False)
    alcohol_heavy = Column(Boolean, default=False)
    stress_high = Column(Boolean, default=False)
    active_moderately = Column(Boolean, default=False)
    
    # Chronic Conditions
    has_high_bp = Column(Boolean, default=False)
    has_high_cholesterol = Column(Boolean, default=False)
    has_diabetes = Column(Boolean, default=False)
    
    # Family History
    family_heart_attack = Column(Boolean, default=False)
    family_stroke = Column(Boolean, default=False)
    family_high_bp = Column(Boolean, default=False)

    owner = relationship("User", back_populates="medical_records")

class LocationRecord(Base):
    __tablename__ = "location_records"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("users.id"))
    latitude = Column(Float)
    longitude = Column(Float)
    timestamp = Column(DateTime, default=datetime.utcnow)

    owner = relationship("User", back_populates="location_history")

class DoctorProfile(Base):
    __tablename__ = "doctor_profiles"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("users.id"))
    specialty = Column(String)
    license_number = Column(String)
    hospital_name = Column(String)
    wallet_address = Column(String, nullable=True) # For blockchain
    
    user = relationship("User", back_populates="doctor_profile")

class MedicalRecord(Base):
    __tablename__ = "health_medical_records"
    id = Column(Integer, primary_key=True, index=True)
    patient_id = Column(String, ForeignKey("users.id"))
    record_type = Column(String) # report, prescription, scan
    title = Column(String)
    description = Column(Text, nullable=True)
    hospital_name = Column(String, nullable=True)
    doctor_name = Column(String, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    version = Column(Integer, default=1)
    is_active = Column(Boolean, default=True)
    
    patient = relationship("User", back_populates="health_records", foreign_keys=[patient_id])
    file = relationship("RecordFile", back_populates="record", uselist=False)

class RecordFile(Base):
    __tablename__ = "record_files"
    id = Column(Integer, primary_key=True, index=True)
    record_id = Column(Integer, ForeignKey("health_medical_records.id"))
    ipfs_cid = Column(String, nullable=True)
    s3_key = Column(String, nullable=True)
    hash_sha256 = Column(String)
    file_size = Column(Integer, nullable=True)
    mime_type = Column(String, nullable=True)
    
    record = relationship("MedicalRecord", back_populates="file")

class AccessRequest(Base):
    __tablename__ = "access_requests"
    id = Column(Integer, primary_key=True, index=True)
    doctor_id = Column(String, ForeignKey("users.id"))
    patient_id = Column(String, ForeignKey("users.id"))
    record_id = Column(Integer, ForeignKey("health_medical_records.id"))
    status = Column(String, default="pending") # pending, approved, rejected
    requested_at = Column(DateTime, default=datetime.utcnow)
    expires_in_hours = Column(Integer, default=24)

class AccessPermission(Base):
    __tablename__ = "access_permissions"
    id = Column(Integer, primary_key=True, index=True)
    doctor_id = Column(String, ForeignKey("users.id"))
    patient_id = Column(String, ForeignKey("users.id"))
    record_id = Column(Integer, ForeignKey("health_medical_records.id"))
    granted_at = Column(DateTime, default=datetime.utcnow)
    expires_at = Column(DateTime)
    tx_hash = Column(String, nullable=True) # Blockchain tx
    is_active = Column(Boolean, default=True)

class AuditLog(Base):
    __tablename__ = "audit_logs"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("users.id"))
    action = Column(String) # UPLOAD, VIEW, GRANT, REVOKE
    record_id = Column(Integer, ForeignKey("health_medical_records.id"), nullable=True)
    ip_address = Column(String, nullable=True)
    device_info = Column(String, nullable=True)
    timestamp = Column(DateTime, default=datetime.utcnow)
    tx_hash = Column(String, nullable=True) # Blockchain tx
    
    user = relationship("User", back_populates="audit_logs")

class EmergencyProfile(Base):
    __tablename__ = "emergency_profiles"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("users.id"))
    blood_group = Column(String)
    allergies = Column(Text, nullable=True)
    current_medications = Column(Text, nullable=True)
    critical_conditions = Column(Text, nullable=True)
    emergency_contact_name = Column(String, nullable=True)
    emergency_contact_phone = Column(String, nullable=True)
    is_public = Column(Boolean, default=True)
    
    user = relationship("User", back_populates="emergency_profile")

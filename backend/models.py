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


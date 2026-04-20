from fastapi import FastAPI, Depends, WebSocket, WebSocketDisconnect, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

from backend.database import engine, Base, get_db
from backend.redis_client import redis_client, check_rate_limit
from backend.websocket import manager
from backend.models import (
    User, Vitals, MedicalHistoryForm, Condition, LocationRecord,
    Medicine, Lab, InsurancePlan, Competition, Product, SearchIndex, DoctorProfile
)
from backend.health_passport import router as passport_router
import firebase_admin
from firebase_admin import auth, credentials
from backend.auth import get_current_user

# Initialize Firebase (requires serviceAccountKey.json locally or env var in prod)
try:
    firebase_admin.get_app()
except ValueError:
    try:
        # Use default credentials (works on Render/GCP) or local file
        firebase_admin.initialize_app()
    except Exception:
        # No credentials available (e.g., HF Spaces) — auth endpoints will fail gracefully
        pass


# Pydantic Schemas
class VitalsBase(BaseModel):
    heart_rate: Optional[int] = None
    systolic_bp: Optional[int] = None
    diastolic_bp: Optional[int] = None
    spo2: Optional[int] = None
    glucose: Optional[int] = None

class VitalsCreate(VitalsBase):
    user_id: str

class VitalsResponse(VitalsBase):
    id: int
    user_id: str
    timestamp: datetime
    
    class Config:
        from_attributes = True

class ConditionResponse(BaseModel):
    id: int
    user_id: str
    title: str
    subtitle: Optional[str] = None
    icon_type: str
    is_active: bool
    timestamp: datetime

    class Config:
        from_attributes = True

class UserResponse(BaseModel):
    id: str
    name: Optional[str] = None
    email: Optional[str] = None
    avatar_url: Optional[str] = None
    age: Optional[str] = None
    weight: Optional[str] = None
    blood_group: Optional[str] = None
    dob: Optional[str] = None
    phone: Optional[str] = None
    address: Optional[str] = None
    height: Optional[str] = None
    gender: Optional[str] = None
    membership_type: Optional[str] = None
    member_since: Optional[str] = None
    is_two_factor_enabled: Optional[bool] = None
    digital_twin_status: Optional[str] = None
    wearable_status: Optional[str] = None

    class Config:
        from_attributes = True

class UserUpdate(BaseModel):
    name: Optional[str] = None
    avatar_url: Optional[str] = None
    age: Optional[str] = None
    weight: Optional[str] = None
    blood_group: Optional[str] = None
    dob: Optional[str] = None
    phone: Optional[str] = None
    address: Optional[str] = None
    height: Optional[str] = None
    gender: Optional[str] = None
    membership_type: Optional[str] = None
    is_two_factor_enabled: Optional[bool] = None
    digital_twin_status: Optional[str] = None
    wearable_status: Optional[str] = None

class MedicalHistoryCreate(BaseModel):
    user_id: str
    phone: Optional[str] = None
    dob: Optional[str] = None
    age: Optional[int] = None
    height: Optional[str] = None
    weight: Optional[str] = None
    emergency_contact: Optional[str] = None
    emergency_relationship: Optional[str] = None
    address: Optional[str] = None
    emergency_phone: Optional[str] = None
    physician_name: Optional[str] = None
    physician_specialty: Optional[str] = None
    physician_address: Optional[str] = None
    physician_phone: Optional[str] = None
    under_doctor_care: bool = False
    doctor_care_explanation: Optional[str] = None
    last_physical_exam: Optional[str] = None
    had_exercise_test: Optional[str] = None
    exercise_test_results: Optional[str] = None
    takes_medications: bool = False
    medications_list: Optional[str] = None
    recently_hospitalized: bool = False
    hospitalization_explanation: Optional[str] = None
    smokes: bool = False
    is_pregnant: bool = False
    alcohol_heavy: bool = False
    stress_high: bool = False
    active_moderately: bool = False
    has_high_bp: bool = False
    has_high_cholesterol: bool = False
    has_diabetes: bool = False

class LocationCreate(BaseModel):
    user_id: str
    latitude: float
    longitude: float

class LocationResponse(LocationCreate):
    id: int
    timestamp: datetime

    class Config:
        from_attributes = True

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: Create tables and seed default user
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    
    async with engine.connect() as conn:
        async with AsyncSession(engine) as session:
            # Seed default user for demo
            default_user_query = await session.execute(select(User).where(User.id == "VS-99283"))
            if not default_user_query.scalar_one_or_none():
                new_user = User(
                    id="VS-99283",
                    name="Dr. Julian Vance",
                    email="julian.v@vitalsync.ai",
                    avatar_url="https://ui-avatars.com/api/?name=Julian+Vance&background=random",
                    phone="+1 (555) 000-8829",
                    membership_type="PREMIUM",
                    digital_twin_status="Active"
                )
                session.add(new_user)
                await session.commit()

            # Seed Kavaan Search Data if empty
            medi_check = await session.execute(select(Medicine).limit(1))
            if not medi_check.scalar_one_or_none():
                # 1. Medicines
                session.add_all([
                    Medicine(name="Vitamin C Zinc", composition="Ascorbic Acid, Zinc", brand="Limcee", price=120.0, popularity=500, rating=4.8, review_count=200, description="Immunity booster for cold and flu prevention."),
                    Medicine(name="Paracetamol 500mg", composition="Paracetamol", brand="Dolo", price=30.0, popularity=1000, rating=4.5, review_count=1500, description="Common medicine for fever and mild pain relief (bukhar ki dawai)."),
                    Medicine(name="Biotin Forte", composition="Biotin, Zinc", brand="HealthKart", price=450.0, popularity=300, rating=4.2, review_count=50, description="Nutritional supplement for hair fall and skin health."),
                ])
                # 2. Labs
                session.add_all([
                    Lab(name="Anuj Pathology Lab", test_type="CBC, PCR", city="Bhopal", rating=4.9, review_count=800, popularity=600, description="Top-rated lab for blood tests and pathology in Bhopal."),
                    Lab(name="City Diagnostic Center", test_type="X-Ray, MRI", city="Mumbai", rating=4.6, review_count=1200, popularity=900, description="Comprehensive diagnostic center with advanced imaging."),
                ])
                # 3. Doctors (Seed Profiles for existing user)
                doc_check = await session.execute(select(DoctorProfile).where(DoctorProfile.user_id == "VS-99283"))
                if not doc_check.scalar_one_or_none():
                     session.add(DoctorProfile(user_id="VS-99283", specialty="General Physician", hospital_name="Vance Clinics", license_number="AX-123", is_axio_verified=True))
                
                # 4. Products / Essentials
                session.add_all([
                    Product(name="Whey Protein Isolate", category="Nutrition", price=2500.0, popularity=400, rating=4.7, description="Premium protein supplement for muscle recovery."),
                    Product(name="N95 Medical Mask", category="Safety", price=50.0, popularity=2000, rating=4.4, description="High-protection face mask for virus prevention."),
                ])
                
                # 5. Competitions / FitLeague
                session.add_all([
                    Competition(name="Bhopal Marathon 2026", category="Run", date="Oct 15, 2026", popularity=150, description="Annual city run for fitness enthusiasts in Bhopal."),
                ])
                
                # 6. Insurance
                session.add_all([
                    InsurancePlan(provider_name="Axio Shield", plan_name="Family Optima", monthly_premium=800.0, popularity=50, description="Comprehensive health cover for entire family with zero co-pay."),
                ])
                
                await session.commit()
    
    yield
    
    # Shutdown
    if redis_client:
        try:
            await redis_client.close()
        except:
            pass

app = FastAPI(title="Axiovital Main API", version="1.0.0", lifespan=lifespan)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(passport_router)

@app.get("/")
async def root():
    return {"message": "Axiovital Backend API via FastAPI"}

@app.get("/api/v1/health")
async def health_check():
    try:
        ping = await redis_client.ping()
        redis_status = "ok" if ping else "error"
    except Exception as e:
        redis_status = f"error: {str(e)}"
        
    return {"status": "healthy", "redis": redis_status}

# Vitals Endpoints
@app.post("/api/v1/vitals", response_model=VitalsResponse)
async def create_vitals(vitals: VitalsCreate, db: AsyncSession = Depends(get_db)):
    db_vitals = Vitals(**vitals.model_dump())
    db.add(db_vitals)
    await db.commit()
    await db.refresh(db_vitals)
    return db_vitals

@app.get("/api/v1/vitals/{user_id}", response_model=List[VitalsResponse])
async def get_user_vitals(user_id: str, limit: int = 10, db: AsyncSession = Depends(get_db)):
    query = select(Vitals).where(Vitals.user_id == user_id).order_by(Vitals.timestamp.desc()).limit(limit)
    result = await db.execute(query)
    return result.scalars().all()

# Conditions Endpoints
@app.get("/api/v1/conditions/{user_id}", response_model=List[ConditionResponse])
async def get_user_conditions(user_id: str, db: AsyncSession = Depends(get_db)):
    query = select(Condition).where(Condition.user_id == user_id, Condition.is_active == True)
    result = await db.execute(query)
    return result.scalars().all()

# User Profile Endpoints
@app.get("/api/v1/profile/{user_id}", response_model=UserResponse)
async def get_user_profile(user_id: str, db: AsyncSession = Depends(get_db), current_user: dict = Depends(get_current_user)):
    # Simple check for demo: only allow user to see their own data OR if they are admin
    # In production, current_user['uid'] would be the primary key
    if user_id != "VS-99283" and user_id != current_user.get('uid'):
         raise HTTPException(status_code=403, detail="Not authorized to access this profile")
    
    query = select(User).where(User.id == user_id)
    result = await db.execute(query)
    user = result.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@app.put("/api/v1/profile/{user_id}", response_model=UserResponse)
async def update_user_profile(user_id: str, profile_data: UserUpdate, db: AsyncSession = Depends(get_db), current_user: dict = Depends(get_current_user)):
    if user_id != "VS-99283" and user_id != current_user.get('uid'):
         raise HTTPException(status_code=403, detail="Not authorized to update this profile")
    query = select(User).where(User.id == user_id)
    result = await db.execute(query)
    user = result.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Update fields
    update_data = profile_data.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(user, key, value)
    
    await db.commit()
    await db.refresh(user)
    return user

# Medical History Form Endpoint
@app.post("/api/v1/medical-history")
async def create_medical_history(form_data: MedicalHistoryCreate, db: AsyncSession = Depends(get_db)):
    # 1. Save the form
    db_form = MedicalHistoryForm(**form_data.model_dump())
    db.add(db_form)
    
    # 2. Auto-extract conditions
    extracted_any = False
    now_str = datetime.now().strftime("%b %Y")
    
    if form_data.has_high_bp:
        # Check if already exists
        exists = await db.execute(select(Condition).where(Condition.user_id == form_data.user_id, Condition.title == "Hypertension"))
        if not exists.scalar_one_or_none():
            db.add(Condition(user_id=form_data.user_id, title="Hypertension", subtitle=f"Diagnosed {now_str} • Stable", icon_type="monitor_heart"))
            extracted_any = True
            
    if form_data.has_high_cholesterol:
        exists = await db.execute(select(Condition).where(Condition.user_id == form_data.user_id, Condition.title == "High Cholesterol"))
        if not exists.scalar_one_or_none():
            db.add(Condition(user_id=form_data.user_id, title="High Cholesterol", subtitle=f"Diagnosed {now_str}", icon_type="water_drop"))
            extracted_any = True

    if form_data.has_diabetes:
        exists = await db.execute(select(Condition).where(Condition.user_id == form_data.user_id, Condition.title == "Diabetes"))
        if not exists.scalar_one_or_none():
            db.add(Condition(user_id=form_data.user_id, title="Diabetes", subtitle=f"Diagnosed {now_str}", icon_type="medical_services"))
            extracted_any = True

    await db.commit()
    return {"status": "success", "conditions_extracted": extracted_any}

@app.post("/api/v1/location", response_model=LocationResponse)
async def update_location(location: LocationCreate, db: AsyncSession = Depends(get_db)):
    db_location = LocationRecord(**location.model_dump())
    db.add(db_location)
    await db.commit()
    await db.refresh(db_location)
    return db_location

@app.get("/api/v1/location/{user_id}", response_model=List[LocationResponse])
async def get_location_history(user_id: str, limit: int = 20, db: AsyncSession = Depends(get_db)):
    query = select(LocationRecord).where(LocationRecord.user_id == user_id).order_by(LocationRecord.timestamp.desc()).limit(limit)
    result = await db.execute(query)
    return result.scalars().all()

# ─── KAVAAN SEARCH ENDPOINTS ──────────────────────────────────────

class SearchRequest(BaseModel):
    query: str
    location: Optional[str] = "bhopal"
    user_id: Optional[str] = None

@app.post("/api/v1/semantic-search")
async def kavaan_search(req: SearchRequest, db: AsyncSession = Depends(get_db)):
    query = req.query.lower().strip()
    
    # 1. Preprocessing (Hinglish/Synonyms)
    synonyms = {"bukhar": "fever", "khansi": "cough", "dawai": "medicine", "dr": "doctor"}
    for k, v in synonyms.items():
        if k in query:
            query = query.replace(k, v)

    # 2. Intent Detection (Rules-based)
    intent = "unknown"
    if any(k in query for k in ["doctor", "physician", "surgeon", "clinic"]): intent = "doctor"
    elif any(k in query for k in ["lab", "test", "pathology", "blood"]): intent = "lab"
    elif any(k in query for k in ["medicine", "tablet", "capsule", "syrup"]): intent = "medicine"
    elif any(k in query for k in ["insurance", "policy", "plan"]): intent = "insurance"
    elif any(k in query for k in ["competition", "league", "run", "ride"]): intent = "competition"
    elif any(k in query for k in ["product", "protein", "mask", "essential"]): intent = "product"

    results = []

    # Helper for scoring
    def calculate_score(item_name, item_desc, popularity, rating, review_count, type_intent):
        text_relevance = 0.0
        name_lower = item_name.lower()
        if query in name_lower: text_relevance = 1.0 # Exact match
        elif any(word in name_lower for word in query.split()): text_relevance = 0.6 # Partial
        
        # Mock Semantic Score (using keyword presence in description/content for demo)
        semantic_score = 0.5
        if any(word in item_desc.lower() for word in query.split()): semantic_score = 0.9
        
        # Performance Signals
        import math
        pop_score = math.log10(1 + popularity) / 4.0 # Normalize roughly 0-1
        rate_score = (rating / 5.0) * (math.log10(1 + review_count) / 4.0)
        
        # Category Boost
        intent_boost = 1.5 if type_intent == intent else 1.0
        
        final_score = (
            (0.40 * semantic_score) + 
            (0.30 * text_relevance) + 
            (0.15 * pop_score) + 
            (0.10 * rate_score) + 
            (0.05 * 0.5) # Personalization mock
        ) * intent_boost
        
        return round(final_score, 3)

    # 3. Search Across Entities (Simulated Hybrid Search)
    # Note: In a real app, this would be a single vector query or parallel SQL queries
    
    # Doctors
    docs_query = await db.execute(select(DoctorProfile).join(User))
    for d in docs_query.scalars().all():
        score = calculate_score(d.user.name, f"{d.specialty} {d.hospital_name}", 500, 4.8, 100, "doctor")
        if score > 0.3:
            results.append({"id": f"doc_{d.id}", "type": "doctor", "name": d.user.name, "subtitle": d.specialty, "rating": 4.8, "score": score})

    # Medicines
    meds_query = await db.execute(select(Medicine))
    for m in meds_query.scalars().all():
        score = calculate_score(m.name, m.description, m.popularity, m.rating, m.review_count, "medicine")
        if score > 0.3:
            results.append({"id": f"med_{m.id}", "type": "medicine", "name": m.name, "subtitle": m.brand, "rating": m.rating, "price": m.price, "score": score})

    # Labs
    labs_query = await db.execute(select(Lab))
    for l in labs_query.scalars().all():
        score = calculate_score(l.name, l.description, l.popularity, l.rating, l.review_count, "lab")
        if score > 0.3:
            results.append({"id": f"lab_{l.id}", "type": "lab", "name": l.name, "subtitle": l.test_type, "rating": l.rating, "score": score})

    # Users (Social Search)
    users_query = await db.execute(select(User))
    for u in users_query.scalars().all():
        # Search by name or Axio-ID
        if query in u.name.lower() or query in u.id.lower():
            results.append({"id": f"user_{u.id}", "type": "user", "name": u.name, "subtitle": f"Axio-ID: {u.id}", "rating": 5.0, "score": 1.0})

    # 4. Ranking & Sorting
    results = sorted(results, key=lambda x: x["score"], reverse=True)[:20]

    return {"results": results, "intent": intent}

@app.get("/api/v1/admin/users", response_model=List[UserResponse])
async def get_all_users(db: AsyncSession = Depends(get_db)):
    """
    Admin endpoint to view all registered users.
    Useful for local monitoring and debugging.
    """
    query = select(User)
    result = await db.execute(query)
    return result.scalars().all()

@app.get("/api/v1/limited", dependencies=[Depends(check_rate_limit)])
async def rate_limited_endpoint(user_id: str = "anonymous"):
    # This endpoint allows max 100 requests per 60 seconds (default via dependency)
    return {"message": "This is a rate-limited endpoint"}

@app.websocket("/ws/{user_id}")
async def websocket_endpoint(websocket: WebSocket, user_id: str):
    await manager.connect(websocket, user_id)
    try:
        while True:
            data = await websocket.receive_text()
            # Echo back for demo
            await manager.send_personal_message(f"Echo: {data}", user_id)
    except WebSocketDisconnect:
        manager.disconnect(websocket, user_id)

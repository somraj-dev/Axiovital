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
from backend.services.search_service import SearchService
import json

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
                    Medicine(name="Amoxicillin 500mg", composition="Amoxicillin", brand="Novamox", price=85.0, popularity=800, rating=4.6, review_count=600, description="Broad-spectrum antibiotic for bacterial infections."),
                    Medicine(name="Cetirizine 10mg", composition="Cetirizine", brand="Okacet", price=25.0, popularity=900, rating=4.4, review_count=400, description="Antihistamine for allergy relief and sneezing."),
                ])
                # 2. Labs
                session.add_all([
                    Lab(name="Anuj Pathology Lab", test_type="CBC, PCR", city="Bhopal", rating=4.9, review_count=800, popularity=600, description="Top-rated lab for blood tests and pathology in Bhopal."),
                    Lab(name="City Diagnostic Center", test_type="X-Ray, MRI", city="Mumbai", rating=4.6, review_count=1200, popularity=900, description="Comprehensive diagnostic center with advanced imaging."),
                    Lab(name="Apollo Diagnostics", test_type="Full Body Checkup", city="Delhi", rating=4.8, review_count=2500, popularity=1500, description="Premium diagnostic services with home collection."),
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
                
                # --- VECTOR INDEXING (The "3 Vector Search" Enablement) ---
                # Populate SearchIndex for Doctors, Medicines, and Labs
                print("Enabling Full Capacity Vector Search...")
                
                # 1. Doctors
                docs = await session.execute(select(DoctorProfile).join(User))
                for d in docs.scalars().all():
                    content = f"{d.user.name} {d.specialty} {d.hospital_name} {d.license_number}"
                    embedding = SearchService.generate_embedding(content)
                    session.add(SearchIndex(
                        entity_id=str(d.id),
                        entity_type="doctor",
                        name=d.user.name,
                        content=content,
                        embedding=json.dumps(embedding)
                    ))
                
                # 2. Medicines
                meds = await session.execute(select(Medicine))
                for m in meds.scalars().all():
                    content = f"{m.name} {m.composition} {m.brand} {m.description}"
                    embedding = SearchService.generate_embedding(content)
                    session.add(SearchIndex(
                        entity_id=str(m.id),
                        entity_type="medicine",
                        name=m.name,
                        content=content,
                        embedding=json.dumps(embedding)
                    ))
                
                # 3. Labs
                labs = await session.execute(select(Lab))
                for l in labs.scalars().all():
                    content = f"{l.name} {l.test_type} {l.city} {l.description}"
                    embedding = SearchService.generate_embedding(content)
                    session.add(SearchIndex(
                        entity_id=str(l.id),
                        entity_type="lab",
                        name=l.name,
                        content=content,
                        embedding=json.dumps(embedding)
                    ))
                
                await session.commit()
                print("Vector Search indexing complete.")
    
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
    query_text = req.query.lower().strip()
    
    # 1. Preprocessing (Hinglish/Synonyms)
    synonyms = {"bukhar": "fever", "khansi": "cough", "dawai": "medicine", "dr": "doctor"}
    for k, v in synonyms.items():
        if k in query_text:
            query_text = query_text.replace(k, v)

    # 2. Intent Detection
    intent = "unknown"
    if any(k in query_text for k in ["doctor", "physician", "surgeon", "clinic"]): intent = "doctor"
    elif any(k in query_text for k in ["lab", "test", "pathology", "blood"]): intent = "lab"
    elif any(k in query_text for k in ["medicine", "tablet", "capsule", "syrup"]): intent = "medicine"

    # 3. Generate Query Embedding
    query_embedding = SearchService.generate_embedding(query_text)

    # 4. Search across SearchIndex (Full Capacity Vector Search)
    # Note: In a production environment with millions of rows, we'd use pgvector's <-> operator.
    # Here we perform similarity on the fetched candidates for "Full Capacity" accuracy.
    idx_query = await db.execute(select(SearchIndex))
    candidates = idx_query.scalars().all()
    
    results = []
    for item in candidates:
        # Determine base stats for scoring (linking back to original tables if needed, 
        # but for demo we'll use reasonable defaults or check intent)
        
        # Text relevance check
        text_relevance = 1.0 if query_text in item.name.lower() else 0.5
        
        # Scoring with SearchService
        score = SearchService.calculate_hybrid_score(
            query_embedding=query_embedding,
            entity_embedding_json=item.embedding,
            text_relevance=text_relevance,
            popularity=500, # Mocked
            rating=4.5, # Mocked
            review_count=100, # Mocked
            is_matching_intent=(item.entity_type == intent)
        )
        
        if score > 0.4:
            results.append({
                "id": item.entity_id,
                "type": item.entity_type,
                "name": item.name,
                "subtitle": item.content[:60] + "...",
                "score": score
            })

    # 5. Ranking & Sorting
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

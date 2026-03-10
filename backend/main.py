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
from backend.models import User, Vitals, MedicalHistoryForm, Condition

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
                    name="Alexander Chen",
                    email="alex.j@vitalsync.ai"
                )
                session.add(new_user)
                
                # Seed default conditions for demo match
                session.add(Condition(user_id="VS-99283", title="Hypertension", subtitle="Diagnosed Feb 2022 • Stable", icon_type="monitor_heart"))
                session.add(Condition(user_id="VS-99283", title="Chronic Asthma", subtitle="Mild Persistent • Seasonal", icon_type="air"))
                
                await session.commit()
    
    yield
    
    # Shutdown
    await redis_client.close()

app = FastAPI(title="Axiovital Main API", version="1.0.0", lifespan=lifespan)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

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

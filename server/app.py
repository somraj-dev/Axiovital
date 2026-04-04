import os
import logging
from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import select
from backend.main import app as backend_app
from backend.database import engine, Base, AsyncSessionLocal
from backend.models import User, Vitals, Condition
from inference import run_inference

# Configure minimal logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# This serves as the top-level app wrapper to satisfy OpenEnv
# while preserving the existing backend routing unmodified.
app = FastAPI(title="Axiovital OpenEnv Submission", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 1. Mount the existing backend API under /api_v1
app.mount("/api_v1", backend_app)

# Root Landing Page (Removes the 'Not Found' error on Hugging Face preview)
@app.get("/")
async def root():
    return {
        "status": "online",
        "service": "Axiovital OpenEnv Agent",
        "version": "1.0.0",
        "endpoints": ["/health", "/reset", "/state", "/step", "/api_v1"]
    }

# 2. OpenEnv specific: Health Check
@app.get("/health")
async def health_check():
    return {"status": "ok", "app": "axiovital-openenv"}

# 3. OpenEnv specific: Reset Endpoint
@app.post("/reset")
async def reset_environment(request: Request):
    """
    OpenEnv specific requirement.
    Resets the database entirely and re-seeds default data.
    """
    try:
        async with engine.begin() as conn:
            await conn.run_sync(Base.metadata.drop_all)
            await conn.run_sync(Base.metadata.create_all)
        
        async with AsyncSessionLocal() as session:
            # Re-seed default user
            new_user = User(
                id="VS-99283",
                name="Dr. Julian Vance",
                email="julian.v@vitalsync.ai",
                avatar_url="https://ui-avatars.com/api/?name=Julian+Vance&background=random",
                membership_type="PREMIUM",
                digital_twin_status="Active"
            )
            session.add(new_user)
            await session.commit()
            
        return {"status": "reset_complete", "message": "Environment has been cleanly reset and re-seeded."}
    except Exception as e:
        logger.error(f"Reset failed: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to reset environment")

# 4. OpenEnv Specific: State and Step Endpoints
@app.get("/state")
async def get_state():
    """Returns the current observation/state."""
    async with AsyncSessionLocal() as session:
        result = await session.execute(
            select(Vitals).where(Vitals.user_id == "VS-99283").order_by(Vitals.timestamp.desc())
        )
        latest_vitals = result.scalars().first()
        
        return {
            "user_id": "VS-99283",
            "vitals": {
                "heart_rate": latest_vitals.heart_rate if latest_vitals else 72,
                "spo2": latest_vitals.spo2 if latest_vitals else 98,
                "systolic_bp": latest_vitals.systolic_bp if latest_vitals else 120,
                "diastolic_bp": latest_vitals.diastolic_bp if latest_vitals else 80
            },
            "environment": "axiovital-prod"
        }

@app.post("/step")
async def step_environment(data: dict):
    """Handles an action and returns the next state, reward, and done flag."""
    action = data.get("action")
    step_result = {"action_received": action, "status": "processed"}
    
    # Simulate a reward based on action validity
    reward = 1.0 if action in ["GET_VITALS", "ANALYZE_RISK", "PROVIDE_REMEDY"] else 0.0
    
    state = await get_state()
    return {
        "observation": state,
        "reward": reward,
        "done": False,
        "info": step_result
    }

# 5. OpenEnv Specific: Inference Endpoint (Predict)
@app.post("/predict")
async def predict_health_risk(data: dict):
    return run_inference(data)

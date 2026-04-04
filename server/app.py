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

# In-memory state for the current evaluation episode
# (In a real production app, this would be in Redis/Database per session)
episode_state = {
    "task_name": "vitals-check",
    "steps_taken": 0,
    "actions_history": [],
    "score": 0.0
}

# 1. Mount the existing backend API under /api_v1
app.mount("/api_v1", backend_app)

# Root Landing Page
@app.get("/")
async def root():
    return {
        "status": "online",
        "service": "Axiovital OpenEnv Agent",
        "tasks": ["vitals-check", "risk-assessment", "clinical-remedy"]
    }

# 2. OpenEnv specific: Health Check
@app.get("/health")
async def health_check():
    return {"status": "ok", "app": "axiovital-openenv"}

# 3. OpenEnv specific: Reset Endpoint
@app.post("/reset")
async def reset_environment(request: Request):
    """
    Resets the episode and sets the target task.
    Expecting JSON: {"task_name": "..."}
    """
    global episode_state
    try:
        data = await request.json()
        task_name = data.get("task_name", "vitals-check")
        
        # Reset DB (existing logic)
        async with engine.begin() as conn:
            await conn.run_sync(Base.metadata.drop_all)
            await conn.run_sync(Base.metadata.create_all)
        
        # Reset Episode State
        episode_state = {
            "task_name": task_name,
            "steps_taken": 0,
            "actions_history": [],
            "score": 0.0
        }
        
        # Seed Task-Specific Vitals
        async with AsyncSessionLocal() as session:
            # Task 1/2/3 have different patient health profiles
            hr = 115 if task_name != "vitals-check" else 72
            sbp = 155 if task_name == "clinical-remedy" else 120
            
            new_vitals = Vitals(
                user_id="VS-99283",
                heart_rate=hr,
                spo2=96,
                systolic_bp=sbp,
                diastolic_bp=90
            )
            session.add(new_vitals)
            await session.commit()
            
        return {"status": "reset_complete", "task": task_name}
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
        latest = result.scalars().first()
        
        return {
            "task": episode_state["task_name"],
            "instruction": f"Goal for {episode_state['task_name']}: Perform the necessary diagnostic steps for the patient.",
            "observation": {
                "heart_rate": latest.heart_rate if latest else 0,
                "systolic_bp": latest.systolic_bp if latest else 0,
                "history": episode_state["actions_history"]
            }
        }

@app.post("/step")
async def step_environment(data: dict):
    """Handles an action and returns the next state, reward, and done flag."""
    global episode_state
    action = data.get("action", "").upper()
    episode_state["steps_taken"] += 1
    episode_state["actions_history"].append(action)
    
    task = episode_state["task_name"]
    reward = 0.0
    done = False
    
    # 3-Task Grader Logic (Programmatic)
    if task == "vitals-check":
        if action == "GET_VITALS":
            reward = 1.0
            done = True
            
    elif task == "risk-assessment":
        if action == "GET_VITALS": reward = 0.3
        if action == "ANALYZE_RISK":
            reward = 1.0
            done = True
            
    elif task == "clinical-remedy":
        if action == "GET_VITALS": reward = 0.2
        if action == "ANALYZE_RISK": reward = 0.4
        if action == "PROVIDE_REMEDY":
            reward = 1.0
            done = True

    # Limit steps
    if episode_state["steps_taken"] >= 8:
        done = True
        
    state = await get_state()
    return {
        "observation": state,
        "reward": reward,
        "done": done,
        "info": {"action": action, "task": task}
    }

# 5. OpenEnv Specific: Legacy /predict support
@app.post("/predict")
async def predict_health_risk(data: dict):
    return run_inference(data)

import os
from fastapi import FastAPI, Depends, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import text
from backend.main import app as backend_app
from backend.database import engine, Base
from inference import run_inference
import logging

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

# 1. Mount the existing backend API under /api
# Note: since the backend routes are defined directly on its FastAPI app,
# we need to be careful. The easiest way for hackathons is to just
# manually include its router or simply copy the health/reset here.
# For full functionality we mount it.
app.mount("/api_v1", backend_app)

# 2. OpenEnv specific: Health Check
@app.get("/health")
async def health_check():
    return {"status": "ok", "app": "axiovital-openenv"}

# 3. OpenEnv specific: Reset Endpoint
@app.post("/reset")
async def reset_environment(request: Request):
    """
    OpenEnv specific requirement.
    Resets the database entirely.
    """
    try:
        async with engine.begin() as conn:
            await conn.run_sync(Base.metadata.drop_all)
            await conn.run_sync(Base.metadata.create_all)
        return {"status": "reset_complete", "message": "Environment has been cleanly reset."}
    except Exception as e:
        logger.error(f"Reset failed: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to reset environment")

# 4. OpenEnv Specific: Inference Endpoint
class InferenceRequest(dict):
    pass

@app.post("/predict")
async def predict_health_risk(data: dict):
    return run_inference(data)

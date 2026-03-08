from fastapi import FastAPI
from ai_service.config import settings

app = FastAPI(title="Axiovital AI Microservice", version="1.0.0")

@app.get("/")
async def root():
    return {"message": "Axiovital AI Service"}

@app.get("/api/v1/health")
async def health_check():
    return {"status": "healthy", "model_loaded": False}

@app.post("/api/v1/predict")
async def predict(data: dict):
    # Dummy prediction endpoint
    return {"prediction": "success", "confidence": 0.99, "input": data}

from fastapi import FastAPI, Depends, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from backend.database import engine, Base
from backend.redis_client import redis_client, check_rate_limit
from backend.websocket import manager

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup defaults
    async with engine.begin() as conn:
        # Avoid creating tables here in prod, rely on Alembic instead.
        # This is strictly for demonstration to 10k DAU environment scaffold.
        await conn.run_sync(Base.metadata.create_all)
    
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

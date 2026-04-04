import redis.asyncio as redis
from backend.config import settings
from fastapi import HTTPException
import time
import logging

logger = logging.getLogger(__name__)

try:
    redis_client = redis.from_url(settings.redis_url, decode_responses=True)
except Exception as e:
    logger.warning(f"Redis not available: {e}")
    redis_client = None

async def check_rate_limit(user_id: str, limit: int = 100, window_seconds: int = 60):
    if not redis_client:
        return True # Skip rate limiting if redis is down
        
    key = f"rate_limit:{user_id}"
    current_time = int(time.time())
    
    try:
        async with redis_client.pipeline() as pipe:
            # Clean old tokens
            pipe.zremrangebyscore(key, 0, current_time - window_seconds)
            # Add current request
            pipe.zadd(key, {str(current_time): current_time})
            # Set expiry for the sorted set
            pipe.expire(key, window_seconds)
            # Count requests in window
            pipe.zcard(key)
            
            results = await pipe.execute()
            request_count = results[-1]
            
        if request_count > limit:
            raise HTTPException(status_code=429, detail="Too many requests")
    except Exception as e:
        logger.warning(f"Rate limit check failed (ignoring): {e}")
        return True
    return True

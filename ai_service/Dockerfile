FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY ai_service/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY ai_service/ ./ai_service/

# Expose port and run
EXPOSE 8001
CMD ["uvicorn", "ai_service.main:app", "--host", "0.0.0.0", "--port", "8001"]

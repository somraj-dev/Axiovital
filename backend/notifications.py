import firebase_admin
from firebase_admin import messaging, credentials
import os

# Initialize only if credentials exist (avoids crash during local dev without creds)
cred_path = os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
if cred_path and os.path.exists(cred_path):
    try:
        cred = credentials.Certificate(cred_path)
        firebase_admin.initialize_app(cred)
        FIREBASE_INITIALIZED = True
    except Exception as e:
        print(f"Failed to initialize Firebase: {e}")
        FIREBASE_INITIALIZED = False
else:
    FIREBASE_INITIALIZED = False
    print("Firebase admin credentials not found. Notifications disabled.")

async def send_push_notification(token: str, title: str, body: str, data: dict = None):
    if not FIREBASE_INITIALIZED:
        return False
        
    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=body,
        ),
        data=data or {},
        token=token,
    )
    
    try:
        response = messaging.send(message)
        print("Successfully sent message:", response)
        return True
    except Exception as e:
        print(f"Error sending message: {e}")
        return False

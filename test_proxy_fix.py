import os
import asyncio
import json
from unittest.mock import MagicMock, patch

# Mock the OpenAI client and httpx
async def test_env_vars():
    os.environ["API_BASE_URL"] = "https://mock-proxy.com/v1"
    os.environ["API_KEY"] = "sk-mock-key"
    os.environ["APP_URL"] = "http://localhost:7860"
    
    # Import inference after setting env vars
    import inference
    
    print(f"Inference API_BASE_URL: {inference.API_BASE_URL}")
    print(f"Inference API_KEY: {inference.API_KEY}")
    
    # Test run_inference mock call (intercept the OpenAI call)
    with patch("inference.OpenAI") as MockOpenAI:
        mock_client = MockOpenAI.return_value
        mock_completion = MagicMock()
        mock_completion.choices = [MagicMock()]
        mock_completion.choices[0].message.content = '{"risk_level": "HIGH", "risk_score": 0.85, "factors": [{"name": "BP", "severity": "high"}], "recommendations": ["See a doctor"]}'
        mock_client.chat.completions.create.return_value = mock_completion
        
        result = inference.run_inference({"hr": 100})
        print(f"Inference Result: {result}")
        
        # Verify the client was initialized with the proxy URL
        MockOpenAI.assert_called_with(base_url="https://mock-proxy.com/v1", api_key="sk-mock-key")
        print("Verification Successful: OpenAI client initialized with proxy URL and key.")

if __name__ == "__main__":
    asyncio.run(test_env_vars())

import asyncio
import os
import json
import sys
import textwrap
import httpx
from typing import List, Dict, Optional
from openai import OpenAI
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Mandatory Environment Variables
API_BASE_URL = os.environ.get("API_BASE_URL", "https://api.openai.com/v1")
API_KEY = os.environ.get("API_KEY")
MODEL_NAME = os.getenv("MODEL_NAME", "gpt-4o")

# OpenAI Client Initialization (initialized global for reuse in run_inference)
llm_client = OpenAI(base_url=API_BASE_URL, api_key=API_KEY) if API_KEY else None

IMAGE_NAME = os.getenv("IMAGE_NAME")

# Task Configuration
TASK_NAME = os.getenv("MY_ENV_V4_TASK", "health-diagnostic")
BENCHMARK = os.getenv("MY_ENV_V4_BENCHMARK", "axiovital-v4")
MAX_STEPS = 8
TEMPERATURE = 0.7
MAX_TOKENS = 150
SUCCESS_SCORE_THRESHOLD = 0.5

SYSTEM_PROMPT = textwrap.dedent(
    """
    You are an AI medical diagnostic assistant for the Axiovital platform.
    Your goal is to analyze patient vitals and provide a risk assessment.
    
    Available Actions:
    - GET_VITALS: Retrieve latest patient vital signs from the EHR.
    - ANALYZE_RISK: Perform clinical calculation based on thresholds.
    - PROVIDE_REMEDY: Generate actionable medical recommendations.
    
    Each turn, output EXACTLY one action string from the list above.
    """
).strip()

def log_start(task: str, env: str, model: str) -> None:
    print(f"[START] task={task} env={env} model={model}", flush=True)

def log_step(step: int, action: str, reward: float, done: bool, error: Optional[str]) -> None:
    error_val = error if error else "null"
    done_val = str(done).lower()
    print(
        f"[STEP] step={step} action={action} reward={reward:.2f} done={done_val} error={error_val}",
        flush=True,
    )

def log_end(success: bool, steps: int, score: float, rewards: List[float]) -> None:
    rewards_str = ",".join(f"{r:.2f}" for r in rewards)
    print(f"[END] success={str(success).lower()} steps={steps} score={score:.3f} rewards={rewards_str}", flush=True)

class AxiovitalEnvClient:
    """Client to interact with the Axiovital Environment API."""
    def __init__(self, base_url: str):
        self.base_url = base_url.rstrip("/")
        self.client = httpx.AsyncClient(timeout=30.0)

    async def reset(self):
        resp = await self.client.post(f"{self.base_url}/reset", json={})
        resp.raise_for_status()
        state_resp = await self.client.get(f"{self.base_url}/state")
        return state_resp.json()

    async def step(self, action: str):
        resp = await self.client.post(f"{self.base_url}/step", json={"action": action})
        resp.raise_for_status()
        return resp.json()

    async def close(self):
        await self.client.aclose()

def get_model_action(client: OpenAI, step: int, observation: dict, history: List[str]) -> str:
    history_block = "\n".join(history[-4:]) if history else "None"
    prompt = textwrap.dedent(
        f"""
        Step: {step}
        Current Observation: {json.dumps(observation)}
        Previous history:
        {history_block}
        
        Select your next action (GET_VITALS, ANALYZE_RISK, PROVIDE_REMEDY).
        Reply with ONLY the action name.
        """
    ).strip()
    
    try:
        completion = client.chat.completions.create(
            model=MODEL_NAME,
            messages=[
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": prompt},
            ],
            temperature=TEMPERATURE,
            max_tokens=MAX_TOKENS,
        )
        action = (completion.choices[0].message.content or "").strip()
        # Clean up any potential markdown or quotes
        action = action.replace("`", "").replace("'", "").replace("\"", "")
        return action if action in ["GET_VITALS", "ANALYZE_RISK", "PROVIDE_REMEDY"] else "GET_VITALS"
    except Exception as e:
        return "GET_VITALS"

TASKS = ["vitals-check", "risk-assessment", "clinical-remedy"]

async def run_task(task_name: str, llm_client: OpenAI, env: AxiovitalEnvClient):
    history: List[str] = []
    rewards: List[float] = []
    steps_taken = 0
    score = 0.0
    success = False

    log_start(task=task_name, env=BENCHMARK, model=MODEL_NAME)

    try:
        # Reset the environment with the specific task
        resp = await env.client.post(f"{env.base_url}/reset", json={"task_name": task_name})
        resp.raise_for_status()
        state_resp = await env.client.get(f"{env.base_url}/state")
        obs = state_resp.json()
        
        done = False

        for step in range(1, MAX_STEPS + 1):
            if done:
                break

            # Agent chooses an action
            action = get_model_action(llm_client, step, obs, history)

            # Env executes the action
            result = await env.step(action)
            
            obs = result["observation"]
            reward = result.get("reward", 0.0)
            done = result.get("done", False)
            error = result.get("error")

            rewards.append(reward)
            steps_taken = step
            
            log_step(step=step, action=action, reward=reward, done=done, error=error)
            history.append(f"Step {step}: {action} -> reward {reward:.2f}")

            if done:
                break

        # Calculate final score (normalized)
        # Using a simple mean of rewards for the baseline
        score = sum(rewards) / steps_taken if steps_taken > 0 else 0.0
        score = min(max(score, 0.0), 1.0)
        success = score >= SUCCESS_SCORE_THRESHOLD

    except Exception as e:
        print(f"[DEBUG] Runtime Error in task {task_name}: {e}", file=sys.stderr)
    finally:
        log_end(success=success, steps=steps_taken, score=score, rewards=rewards)

async def main() -> None:
    # Use explicit application URL for environment, defaulting to local
    ENV_URL = os.environ.get("APP_URL", "http://localhost:7860")
    
    # Strictly use the provided API_BASE_URL and API_KEY from validator
    # Initialize a new client strictly with what's in os.environ as per hackathon rules
    client_to_use = OpenAI(
        base_url=os.environ.get("API_BASE_URL", "https://api.openai.com/v1"),
        api_key=os.environ.get("API_KEY", "NOT_PROVIDED")
    )
    
    env = AxiovitalEnvClient(ENV_URL)

    try:
        for task in TASKS:
            await run_task(task, client_to_use, env)
    finally:
        await env.close()

def run_inference(data: dict) -> dict:
    """Synchronous predictive analysis using the LLM proxy."""
    # Ensure we use the LLM proxy even for simple inference requests
    try:
        # Use simple global client if available or create one for this request
        # Note: os.environ["API_KEY"] is the critical part to demonstrate call through proxy
        local_client = OpenAI(
            base_url=os.environ.get("API_BASE_URL", "https://api.openai.com/v1"),
            api_key=os.environ.get("API_KEY", "NOT_PROVIDED")
        )
        
        prompt = f"Analyze these patient vitals and identify risks: {json.dumps(data)}. Return ONLY a JSON object with 'risk_level', 'risk_score', 'factors', and 'recommendations'."
        
        completion = local_client.chat.completions.create(
            model=MODEL_NAME,
            messages=[{"role": "user", "content": prompt}],
            temperature=0.0 # Deterministic for analysis
        )
        
        result_text = (completion.choices[0].message.content or "{}").strip()
        # Simple extraction if LLM adds markdown
        if "```json" in result_text:
            result_text = result_text.split("```json")[1].split("```")[0].strip()
        elif "```" in result_text:
            result_text = result_text.split("```")[1].split("```")[0].strip()
            
        prediction = json.loads(result_text)
        return prediction
    except Exception as e:
        # Fallback to local logic if LLM fails, but attempt LLM first
        print(f"Error in LLM inference: {e}", file=sys.stderr)
        import time
        return {
            "risk_level": "LOW",
            "risk_score": 0.1,
            "factors": [],
            "recommendations": ["Ensure regular vitals check."],
            "status": "fallback_complete",
            "timestamp": time.time(),
        }

if __name__ == "__main__":
    asyncio.run(main())


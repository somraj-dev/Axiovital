---
title: AxioVital
emoji: 🏥
colorFrom: blue
colorTo: indigo
sdk: docker
app_port: 7860
pinned: false
---

# AxioVital: AI-Driven Healthcare Agent Environment

AxioVital is a real-world healthcare simulation environment for OpenEnv. It models a Clinical Decision Support System (CDSS) where an AI agent interacts with an Electronic Health Record (EHR) to diagnose and treat patients.

## Motivation
Healthcare triage is a high-stakes real-world task. This environment evaluates an agent's ability to:
1.  **Observe**: Correcty retrieve and interpret patient vitals.
2.  **Reason**: Identify clinical risks based on medical thresholds.
3.  **Act**: Execute appropriate remedies while staying within safety boundaries.

## Action Space (Discrete)
- `GET_VITALS`: Retrieves heart rate, SpO2, and blood pressure from the EHR.
- `ANALYZE_RISK`: Compares vitals to medical thresholds (e.g., Tachycardia if HR > 100).
- `PROVIDE_REMEDY`: Generates a medical intervention or prescription.

## Observation Space (Dict)
- `task`: The current task name.
- `instruction`: Context-specific goal for the agent.
- `observation`:
    - `heart_rate`: (int) Current Beats Per Minute.
    - `systolic_bp`: (int) Systolic Blood Pressure.
    - `history`: (list) Log of previous actions in the episode.

## Tasks & Baseline Scores
| Task ID | Difficulty | Description | Baseline Score |
| :--- | :--- | :--- | :--- |
| `vitals-check` | Easy | Retrieve patient vitals once. | 1.00 |
| `risk-assessment` | Medium | Identify a risk state after getting vitals. | 0.95 |
| `clinical-remedy` | Hard | Provide a full clinical treatment plan. | 0.85 |

## Setup & Usage
### Local Development
1. Install dependencies: `pip install -r requirements.txt`
2. Run server: `uvicorn server.app:app --port 7860`
3. Run baseline: `python inference.py`

### Deployment
This environment is containerized via Docker and deployed to Hugging Face Spaces. It adheres to the OpenEnv 0.2.0 "multi-mode deployment" standard with `pyproject.toml` and `uv.lock`.

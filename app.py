import gradio as gr
from inference import run_inference

def assess_health(heart_rate, spo2, systolic_bp, diastolic_bp, glucose):
    """
    Interface between Gradio UI and the AI Inference engine.
    """
    data = {
        "heart_rate": heart_rate,
        "spo2": spo2,
        "systolic_bp": systolic_bp,
        "diastolic_bp": diastolic_bp,
        "glucose": glucose
    }
    
    result = run_inference(data)
    
    # Format the output for the dashboard
    risk_level = result["risk_level"]
    score = result["risk_score"]
    factors = result["factors"]
    recommendations = result["recommendations"]
    
    # Styling based on risk
    color_map = {
        "LOW": "#10b981",      # Emerald
        "MODERATE": "#f59e0b", # Amber
        "HIGH": "#ef4444",     # Red
        "CRITICAL": "#7f1d1d"  # Maroon
    }
    color = color_map.get(risk_level, "#6b7280")
    
    # Build HTML for factors
    factors_html = ""
    if not factors:
        factors_html = "<p style='color: #6b7280;'>No abnormal factors detected.</p>"
    else:
        for f in factors:
            severity_color = "#ef4444" if f["severity"] in ["high", "critical"] else "#f59e0b"
            factors_html += f"<div style='margin-bottom: 8px;'><span style='background: {severity_color}; color: white; padding: 2px 8px; border-radius: 12px; font-size: 0.8em; margin-right: 8px;'>{f['severity'].upper()}</span> <b>{f['name']}</b></div>"
    
    # Build HTML for recommendations
    rec_html = "<ul>"
    for r in recommendations:
        rec_html += f"<li>{r}</li>"
    rec_html += "</ul>"
    
    # Final Dashboard HTML
    dashboard_html = f"""
    <div style="background: white; padding: 24px; border-radius: 16px; border: 1px solid #e5e7eb; box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h2 style="margin: 0; color: #111827;">Analysis Results</h2>
            <span style="background: {color}; color: white; padding: 4px 12px; border-radius: 20px; font-weight: 700;">{risk_level}</span>
        </div>
        
        <div style="margin-bottom: 24px;">
            <p style="margin: 0 0 8px 0; color: #4b5563; font-size: 0.9em;">Overall Risk Probability</p>
            <div style="width: 100%; background: #f3f4f6; height: 12px; border-radius: 6px;">
                <div style="width: {score * 100}%; background: {color}; height: 100%; border-radius: 6px; transition: width 0.5s ease-out;"></div>
            </div>
            <p style="text-align: right; margin: 4px 0 0 0; font-weight: 600; color: {color};">{int(score * 100)}%</p>
        </div>
        
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
            <div>
                <h3 style="font-size: 1em; color: #374151; margin-bottom: 12px;">Detected Factors</h3>
                {factors_html}
            </div>
            <div>
                <h3 style="font-size: 1em; color: #374151; margin-bottom: 12px;">Clinical Recommendations</h3>
                <div style="color: #4b5563; font-size: 0.95em;">{rec_html}</div>
            </div>
        </div>
    </div>
    """
    
    return dashboard_html

# Custom CSS for Premium Medical Look
custom_css = """
footer {visibility: hidden}
.gradio-container {background-color: #f9fafb}
#header {text-align: center; margin-bottom: 30px}
#header h1 {color: #111827; font-weight: 800; font-size: 2.5em; margin-bottom: 10px}
#header p {color: #6b7280; font-size: 1.1em}
.input-card {background: white; padding: 20px; border-radius: 12px; border: 1px solid #e5e7eb}
"""

with gr.Blocks(theme=gr.themes.Soft(), css=custom_css) as demo:
    with gr.Div(elem_id="header"):
        gr.Markdown("# Axiovital Clinical Portal")
        gr.Markdown("Real-time AI Vitals Assessment & Health Risk Stratification")
    
    with gr.Row():
        with gr.Column(scale=1):
            with gr.Div(elem_classes="input-card"):
                gr.Markdown("### Patient Vitals")
                hr = gr.Slider(minimum=30, maximum=220, value=75, label="Heart Rate (BPM)")
                spo2 = gr.Slider(minimum=70, maximum=100, value=98, label="SpO2 (%)")
                with gr.Row():
                    sys = gr.Number(value=120, label="Systolic BP")
                    dia = gr.Number(value=80, label="Diastolic BP")
                glu = gr.Number(value=100, label="Blood Glucose (mg/dL)")
                
                btn = gr.Button("Analyze Health Status", variant="primary")
        
        with gr.Column(scale=2):
            output = gr.HTML(label="Medical Dashboard")
    
    btn.click(
        fn=assess_health,
        inputs=[hr, spo2, sys, dia, glu],
        outputs=output
    )
    
    gr.Markdown(
        """
        ---
        **⚠️ Medical Disclaimer:** 
        This application is for educational and hackathon demonstration purposes only. The assessments provided are based on automated algorithms and should **NOT** be used as a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition.
        """,
        elem_id="disclaimer"
    )

if __name__ == "__main__":
    demo.launch()

from typing import List, Dict

class HealthRiskAssessor:
    def __init__(self):
        pass

    def predict(self, heart_rate: float = None, spo2: float = None, systolic_bp: float = None, diastolic_bp: float = None, glucose: float = None) -> Dict:
        """
        Predicts health risk based on clinical thresholds.
        """
        factors = []
        risk_score = 0.0
        
        # 1. Heart Rate Analysis (Tachycardia / Bradycardia)
        if heart_rate:
            if heart_rate > 100:
                factors.append({"name": "Tachycardia", "severity": "moderate" if heart_rate < 120 else "high"})
                risk_score += 0.3 if heart_rate < 120 else 0.6
            elif heart_rate < 60:
                factors.append({"name": "Bradycardia", "severity": "moderate" if heart_rate > 50 else "high"})
                risk_score += 0.2 if heart_rate > 50 else 0.5

        # 2. SpO2 Analysis (WHO Hypoxemia classification)
        if spo2:
            if spo2 < 90:
                factors.append({"name": "Severe Hypoxemia", "severity": "critical"})
                risk_score += 0.9
            elif spo2 < 95:
                factors.append({"name": "Mild Hypoxemia", "severity": "moderate"})
                risk_score += 0.4

        # 3. Blood Pressure Analysis (AHA thresholds)
        if systolic_bp and diastolic_bp:
            if systolic_bp >= 180 or diastolic_bp >= 120:
                factors.append({"name": "Hypertensive Crisis", "severity": "critical"})
                risk_score += 0.95
            elif systolic_bp >= 140 or diastolic_bp >= 90:
                factors.append({"name": "Hypertension Stage 2", "severity": "high"})
                risk_score += 0.6
            elif systolic_bp >= 130 or diastolic_bp >= 80:
                factors.append({"name": "Hypertension Stage 1", "severity": "moderate"})
                risk_score += 0.3
            elif systolic_bp >= 120 and diastolic_bp < 80:
                factors.append({"name": "Elevated Blood Pressure", "severity": "low"})
                risk_score += 0.1

        # 4. Glucose Analysis (ADA classification)
        if glucose:
            if glucose > 200:
                factors.append({"name": "Hyperglycemia", "severity": "high"})
                risk_score += 0.7
            elif glucose < 70:
                factors.append({"name": "Hypoglycemia", "severity": "critical"})
                risk_score += 0.8

        # Normalize score
        risk_score = min(1.0, risk_score)

        # Determine risk level
        if risk_score >= 0.8:
            risk_level = "CRITICAL"
        elif risk_score >= 0.5:
            risk_level = "HIGH"
        elif risk_score >= 0.2:
            risk_level = "MODERATE"
        else:
            risk_level = "LOW"
            
        # Generate recommendations
        recommendations = []
        if risk_level == "CRITICAL":
            recommendations.append("Seek immediate emergency medical attention.")
        elif risk_level == "HIGH":
            recommendations.append("Consult a healthcare provider as soon as possible.")
        elif risk_level == "MODERATE":
            recommendations.append("Monitor vitals closely and schedule a routine checkup.")
        else:
            recommendations.append("Vitals are within acceptable ranges. Maintain a healthy lifestyle.")

        return {
            "risk_level": risk_level,
            "risk_score": round(risk_score, 2),
            "factors": factors,
            "recommendations": recommendations,
            "confidence": 0.95,
            "status": "success"
        }

assessor = HealthRiskAssessor()

def run_inference(data: dict) -> dict:
    """Wrapper function to match expected interface"""
    return assessor.predict(
        heart_rate=data.get("heart_rate"),
        spo2=data.get("spo2"),
        systolic_bp=data.get("systolic_bp"),
        diastolic_bp=data.get("diastolic_bp"),
        glucose=data.get("glucose")
    )

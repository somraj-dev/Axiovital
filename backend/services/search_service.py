import numpy as np
from sentence_transformers import SentenceTransformer
from typing import List, Optional
import json

class SearchService:
    _model = None

    @classmethod
    def get_model(cls):
        if cls._model is None:
            # Using the same model as the Supabase Edge Function for consistency
            cls._model = SentenceTransformer('all-MiniLM-L6-v2')
        return cls._model

    @classmethod
    def generate_embedding(cls, text: str) -> List[float]:
        """Generates a 384-dimensional embedding for the given text."""
        model = cls.get_model()
        embedding = model.encode(text, normalize_embeddings=True)
        return embedding.tolist()

    @staticmethod
    def cosine_similarity(v1: List[float], v2: List[float]) -> float:
        """Calculates cosine similarity between two vectors."""
        a = np.array(v1)
        b = np.array(v2)
        return float(np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b)))

    @classmethod
    def calculate_hybrid_score(
        cls, 
        query_embedding: List[float], 
        entity_embedding_json: str, 
        text_relevance: float,
        popularity: int,
        rating: float,
        review_count: int,
        is_matching_intent: bool
    ) -> float:
        """
        Implements the Amazon-style ranking algorithm found in the edge functions.
        """
        try:
            entity_embedding = json.loads(entity_embedding_json)
            semantic_score = cls.cosine_similarity(query_embedding, entity_embedding)
        except Exception:
            semantic_score = 0.5 # Fallback
        
        # Popularity (Logarithmic scale)
        pop_score = np.log10(1 + popularity) / 3.0
        
        # Rating Score
        rating_score = (rating / 5.0) * (np.log10(1 + review_count) / 3.0)
        
        # Category Intent Boost
        intent_boost = 1.5 if is_matching_intent else 1.0
        
        final_score = (
            (0.40 * semantic_score) +
            (0.30 * text_relevance) +
            (0.15 * pop_score) +
            (0.10 * rating_score) +
            (0.05 * 0.5) # Mock Personalization
        ) * intent_boost
        
        return round(float(final_score), 3)

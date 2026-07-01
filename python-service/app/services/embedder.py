import os
from functools import lru_cache
from sentence_transformers import SentenceTransformer

MODEL_NAME = os.getenv("EMBEDDING_MODEL", "all-MiniLM-L6-v2")


@lru_cache(maxsize=1)
def get_model() -> SentenceTransformer:
    """Load embedding model once and cache."""
    return SentenceTransformer(MODEL_NAME)


def generate_embeddings(texts: list[str]) -> tuple[list[list[float]], int]:
    """Generate embedding vectors for a list of texts."""
    model = get_model()
    embeddings = model.encode(texts, normalize_embeddings=True, show_progress_bar=False)
    return embeddings.tolist(), model.get_sentence_embedding_dimension()

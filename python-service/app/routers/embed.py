import os
from fastapi import APIRouter, HTTPException, Header, Depends

from app.models.schemas import EmbedRequest, EmbedResponse
from app.services.embedder import generate_embeddings, MODEL_NAME

router = APIRouter()

INTERNAL_SECRET = os.getenv("INTERNAL_SERVICE_SECRET", "dev-secret-change-me")


def verify_internal_secret(x_internal_secret: str = Header(...)):
    if x_internal_secret != INTERNAL_SECRET:
        raise HTTPException(status_code=403, detail="Forbidden: invalid internal secret")
    return True


@router.post("", response_model=EmbedResponse, dependencies=[Depends(verify_internal_secret)])
async def embed_texts(request: EmbedRequest):
    """Generate embedding vectors for a list of text strings."""
    if not request.texts:
        raise HTTPException(status_code=400, detail="No texts provided")

    # Filter empty strings
    texts = [t.strip() for t in request.texts if t and t.strip()]
    if not texts:
        raise HTTPException(status_code=400, detail="All texts were empty")

    try:
        embeddings, dimensions = generate_embeddings(texts)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Embedding generation failed: {str(e)}")

    return EmbedResponse(
        embeddings=embeddings,
        model=MODEL_NAME,
        dimensions=dimensions,
    )

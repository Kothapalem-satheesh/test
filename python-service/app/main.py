import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import extract, embed

app = FastAPI(
    title="ComplianceAI Python Service",
    description="Document parsing, OCR, and embeddings microservice",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(extract.router, prefix="/extract", tags=["extract"])
app.include_router(embed.router, prefix="/embed", tags=["embed"])


@app.get("/health")
async def health():
    return {
        "status": "healthy",
        "service": "complianceai-python",
        "embedding_model": os.getenv("EMBEDDING_MODEL", "all-MiniLM-L6-v2"),
    }

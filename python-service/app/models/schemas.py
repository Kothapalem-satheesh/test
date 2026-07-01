from pydantic import BaseModel, Field

from typing import Optional





class TextChunk(BaseModel):

    content: str

    page_number: Optional[int] = None

    section_title: Optional[str] = None

    chunk_index: int = 0

    token_estimate: int = 0





class ExtractResponse(BaseModel):

    filename: str

    file_type: str

    total_pages: int = 0

    total_chunks: int = 0

    chunks: list[TextChunk] = []

    ocr_pages: list[int] = []





class EmbedRequest(BaseModel):

    texts: list[str] = Field(..., min_length=1, max_length=256)





class EmbedResponse(BaseModel):

    embeddings: list[list[float]]

    model: str

    dimensions: int



import os
from fastapi import APIRouter, UploadFile, File, HTTPException, Header, Depends

from app.models.schemas import ExtractResponse, TextChunk
from app.services.pdf_parser import parse_pdf
from app.services.docx_parser import parse_docx
from app.services.excel_parser import parse_excel
from app.services.chunker import chunk_text, chunk_markdown

router = APIRouter()

INTERNAL_SECRET = os.getenv("INTERNAL_SERVICE_SECRET", "dev-secret-change-me")


def verify_internal_secret(x_internal_secret: str = Header(...)):
    if x_internal_secret != INTERNAL_SECRET:
        raise HTTPException(status_code=403, detail="Forbidden: invalid internal secret")
    return True


@router.post("", response_model=ExtractResponse, dependencies=[Depends(verify_internal_secret)])
async def extract_document(file: UploadFile = File(...)):
    """Extract text chunks from uploaded document."""
    if not file.filename:
        raise HTTPException(status_code=400, detail="No filename provided")

    ext = file.filename.rsplit(".", 1)[-1].lower()
    allowed = {"pdf", "docx", "txt", "md", "xlsx"}
    if ext not in allowed:
        raise HTTPException(status_code=400, detail=f"Unsupported file type: .{ext}")

    file_bytes = await file.read()
    if not file_bytes:
        raise HTTPException(status_code=400, detail="Empty file")

    chunks = []
    total_pages = 0
    ocr_pages = []

    try:
        if ext == "pdf":
            chunks, total_pages, ocr_pages = parse_pdf(file_bytes)
        elif ext == "docx":
            chunks, total_pages = parse_docx(file_bytes)
        elif ext == "txt":
            text = file_bytes.decode("utf-8", errors="replace")
            chunks = chunk_text(text, section_title="Document Content")
            total_pages = 1
        elif ext == "md":
            text = file_bytes.decode("utf-8", errors="replace")
            chunks = chunk_markdown(text)
            total_pages = 1
        elif ext == "xlsx":
            chunks, total_pages = parse_excel(file_bytes)
    except Exception as e:
        raise HTTPException(status_code=422, detail=f"Failed to parse document: {str(e)}")

    text_chunks = [TextChunk(**c) for c in chunks]

    return ExtractResponse(
        filename=file.filename,
        file_type=ext,
        total_pages=total_pages,
        total_chunks=len(text_chunks),
        chunks=text_chunks,
        ocr_pages=ocr_pages,
    )

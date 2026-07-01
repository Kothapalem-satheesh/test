import io
import fitz  # PyMuPDF
import pdfplumber
from PIL import Image
import pytesseract
from app.services.chunker import chunk_text, detect_section_title


def parse_pdf(file_bytes: bytes) -> tuple[list[dict], int, list[int]]:
    """Extract text from PDF with OCR fallback for scanned pages."""
    chunks = []
    ocr_pages = []
    total_pages = 0

    doc = fitz.open(stream=file_bytes, filetype="pdf")
    total_pages = len(doc)

    for page_num in range(total_pages):
        page = doc[page_num]
        text = page.get_text("text").strip()
        page_number = page_num + 1

        # OCR fallback for scanned pages with little extractable text
        if len(text) < 50:
            try:
                pix = page.get_pixmap(dpi=200)
                img = Image.open(io.BytesIO(pix.tobytes("png")))
                ocr_text = pytesseract.image_to_string(img)
                if len(ocr_text.strip()) > len(text):
                    text = ocr_text.strip()
                    ocr_pages.append(page_number)
            except Exception:
                pass

        if text:
            section = detect_section_title(text)
            page_chunks = chunk_text(text, page_number=page_number, section_title=section)
            chunks.extend(page_chunks)

    doc.close()

    # Extract tables via pdfplumber
    try:
        with pdfplumber.open(io.BytesIO(file_bytes)) as pdf:
            for page_num, page in enumerate(pdf.pages):
                tables = page.extract_tables()
                for table in tables:
                    if table:
                        table_text = "\n".join(
                            " | ".join(str(cell or "") for cell in row)
                            for row in table if row
                        )
                        if table_text.strip():
                            table_chunks = chunk_text(
                                f"[Table on page {page_num + 1}]\n{table_text}",
                                page_number=page_num + 1,
                                section_title="Table Data",
                            )
                            chunks.extend(table_chunks)
    except Exception:
        pass

    # Re-index chunks
    for i, chunk in enumerate(chunks):
        chunk["chunk_index"] = i

    return chunks, total_pages, ocr_pages

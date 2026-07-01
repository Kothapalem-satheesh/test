import re
from typing import Optional


def estimate_tokens(text: str) -> int:
    """Rough token estimate: ~4 chars per token for English text."""
    return max(1, len(text) // 4)


def _split_oversized(text: str, max_tokens: int) -> list[str]:
    """Split long text at sentence boundaries when possible."""
    if estimate_tokens(text) <= max_tokens:
        return [text]

    sentences = re.split(r'(?<=[.!?])\s+', text)
    if len(sentences) <= 1:
        words = text.split()
        mid = max(1, len(words) // 2)
        return [
            " ".join(words[:mid]).strip(),
            " ".join(words[mid:]).strip(),
        ]

    parts = []
    current = ""
    for sentence in sentences:
        candidate = f"{current} {sentence}".strip() if current else sentence
        if estimate_tokens(candidate) > max_tokens and current:
            parts.append(current.strip())
            current = sentence
        else:
            current = candidate
    if current.strip():
        parts.append(current.strip())
    return parts


def _overlap_tail(text: str, overlap_tokens: int) -> str:
    if overlap_tokens <= 0:
        return ""
    words = text.split()
    approx_words = max(1, overlap_tokens * 4 // 5)  # ~5 chars per word
    return " ".join(words[-approx_words:]).strip()


def chunk_text(
    text: str,
    page_number: Optional[int] = None,
    section_title: Optional[str] = None,
    min_tokens: int = 100,
    max_tokens: int = 450,
    overlap_tokens: int = 60,
) -> list[dict]:
    """
    Split text into overlapping chunks at paragraph/sentence boundaries.
    Production-oriented: preserves context across chunk boundaries.
    """
    if not text or not text.strip():
        return []

    paragraphs = re.split(r'\n\s*\n', text.strip())
    chunks = []
    current = ""
    current_tokens = 0

    def flush():
        nonlocal current, current_tokens
        content = current.strip()
        if not content:
            return
        if estimate_tokens(content) < min_tokens and chunks:
            prev = chunks[-1]
            merged = f"{prev['content']}\n\n{content}"
            if estimate_tokens(merged) <= max_tokens * 1.2:
                prev['content'] = merged
                prev['token_estimate'] = estimate_tokens(merged)
                current = ""
                current_tokens = 0
                return
        chunks.append({
            "content": content,
            "page_number": page_number,
            "section_title": section_title,
            "chunk_index": len(chunks),
            "token_estimate": estimate_tokens(content),
        })
        tail = _overlap_tail(content, overlap_tokens)
        current = tail
        current_tokens = estimate_tokens(tail) if tail else 0

    for para in paragraphs:
        para = para.strip()
        if not para:
            continue

        for piece in _split_oversized(para, max_tokens):
            piece_tokens = estimate_tokens(piece)
            if current_tokens + piece_tokens > max_tokens and current:
                flush()
            current = f"{current}\n\n{piece}".strip() if current else piece
            current_tokens = estimate_tokens(current)

    if current.strip():
        if estimate_tokens(current) < min_tokens and chunks:
            prev = chunks[-1]
            prev['content'] = f"{prev['content']}\n\n{current.strip()}"
            prev['token_estimate'] = estimate_tokens(prev['content'])
        else:
            chunks.append({
                "content": current.strip(),
                "page_number": page_number,
                "section_title": section_title,
                "chunk_index": len(chunks),
                "token_estimate": estimate_tokens(current),
            })

    for i, c in enumerate(chunks):
        c["chunk_index"] = i
    return chunks


def chunk_markdown(text: str, page_number: Optional[int] = None) -> list[dict]:
    """Section-aware chunking for Markdown policy documents."""
    if not text or not text.strip():
        return []

    lines = text.splitlines()
    sections: list[tuple[str, list[str]]] = []
    current_title = "Document"
    current_lines: list[str] = []

    heading_re = re.compile(r'^(#{1,4})\s+(.+)$')

    for line in lines:
        m = heading_re.match(line.strip())
        if m:
            if current_lines:
                sections.append((current_title, current_lines))
            current_title = m.group(2).strip()
            current_lines = []
        else:
            current_lines.append(line)

    if current_lines:
        sections.append((current_title, current_lines))

    if not sections:
        return chunk_text(text, page_number=page_number, section_title="Document")

    all_chunks = []
    for title, body_lines in sections:
        body = "\n".join(body_lines).strip()
        if not body:
            continue
        section_chunks = chunk_text(
            body,
            page_number=page_number,
            section_title=title,
        )
        for c in section_chunks:
            c["chunk_index"] = len(all_chunks)
            all_chunks.append(c)
    return all_chunks


def detect_section_title(text: str) -> Optional[str]:
    """Detect if a line looks like a section heading."""
    lines = text.strip().split('\n')
    if not lines:
        return None
    first_line = lines[0].strip()
    if len(first_line) < 100 and (
        first_line.isupper() or
        re.match(r'^(\d+\.|\#+\s|[A-Z][a-z]+:)', first_line)
    ):
        return first_line
    return None

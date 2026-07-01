# ComplianceAI

AI-powered Security Compliance Assessment Platform that analyzes uploaded documents (security policies, architecture docs, API specs, requirements) and checks them against security frameworks (NIST CSF, OWASP ASVS, OWASP SAMM), producing scored compliance reports with evidence and remediation recommendations.

## Architecture

```
React (Vite)  ──REST──▶  Node/Express API  ──internal HTTP──▶  Python FastAPI
                              │                                      │
                              │         auth, CRUD, scoring,         │  parsing, OCR,
                              │         LLM calls, reports           │  embeddings
                              ▼                                      ▼
                         Supabase (Postgres + pgvector, Storage, Auth)
```

**Why this split?**
- **Node/Express** handles orchestration: auth, business logic, scoring, LLM reasoning (Claude), and report generation. It's the single API the browser talks to.
- **Python FastAPI** handles ML-heavy work only: document parsing/OCR, text chunking, and embedding generation via sentence-transformers. It's never exposed to the browser — only Express calls it with a shared secret header.
- **Supabase** provides Postgres (with pgvector for semantic search), file storage, and authentication.

## Tech Stack

| Layer | Technologies |
|-------|-------------|
| Frontend | React (JS), Vite, React Router, Tailwind CSS, Recharts, Axios |
| Backend | Node.js, Express (JS), Anthropic Claude API |
| AI Worker | Python, FastAPI, PyMuPDF, pdfplumber, python-docx, openpyxl, pytesseract, sentence-transformers |
| Database | Supabase (Postgres + pgvector + Storage + Auth) |

## Prerequisites

- Node.js 20+
- Python 3.11+
- [Supabase](https://supabase.com) project with pgvector enabled
- [Anthropic API key](https://console.anthropic.com/)
- Tesseract OCR (for scanned PDF support): `apt install tesseract-ocr` or `brew install tesseract`

## Quick Start

### 1. Clone and configure

```bash
cp .env.example .env
# Fill in your Supabase URL, keys, Anthropic API key, and internal secret
```

### 2. Set up Supabase

1. Create a Supabase project at [supabase.com](https://supabase.com)
2. Enable the **pgvector** extension: Database → Extensions → search "vector" → Enable
3. Run the migration: copy contents of `supabase/migrations/001_initial_schema.sql` into the SQL Editor and execute
4. Create a Storage bucket named `documents` (set to public or configure policies)
5. Enable Google OAuth in Authentication → Providers (optional)

### 3. Install dependencies

```bash
# Server
cd server && npm install && cd ..

# Client
cd client && npm install && cd ..

# Python service
cd python-service
python -m venv venv
# Windows: venv\Scripts\activate
# macOS/Linux: source venv/bin/activate
pip install -r requirements.txt
cd ..
```

### 4. Start services

**Option A: Docker Compose (recommended)**

```bash
docker-compose up --build
```

**Option B: Run individually**

```bash
# Terminal 1 - Python service
cd python-service
source venv/bin/activate  # or venv\Scripts\activate on Windows
uvicorn app.main:app --reload --port 8000

# Terminal 2 - Express server
cd server
npm run dev

# Terminal 3 - React client
cd client
npm run dev
```

### 5. Seed framework data

With the Python service running (needed for embedding generation):

```bash
cd server
npm run seed
```

This loads NIST CSF (~35 requirements), OWASP ASVS (~34 requirements), and OWASP SAMM (~35 requirements) with pre-computed embeddings.

### 6. Open the app

Navigate to [http://localhost:5173](http://localhost:5173)

## Environment Variables

See `.env.example` for the full list. Key variables:

| Variable | Service | Description |
|----------|---------|-------------|
| `SUPABASE_URL` | Server + Client | Supabase project URL |
| `SUPABASE_SERVICE_ROLE_KEY` | Server | Service role key (bypasses RLS) |
| `SUPABASE_ANON_KEY` | Server + Client | Public anon key |
| `ANTHROPIC_API_KEY` | Server | Claude API key for compliance reasoning |
| `ANTHROPIC_MODEL` | Server | Model ID (default: claude-sonnet-4-20250514) |
| `INTERNAL_SERVICE_SECRET` | Server + Python | Shared secret for internal API calls |
| `PYTHON_SERVICE_URL` | Server | Python service URL (default: http://localhost:8000) |
| `VITE_API_URL` | Client | Express API URL |
| `VITE_SUPABASE_URL` | Client | Supabase URL for auth |
| `VITE_SUPABASE_ANON_KEY` | Client | Supabase anon key for auth |

## Usage Workflow

1. **Sign up / Log in** — Email/password or Google OAuth via Supabase Auth
2. **Create a project** — Name it and select frameworks (NIST CSF, OWASP ASVS, OWASP SAMM)
3. **Upload documents** — Drag & drop PDF, DOCX, TXT, MD, or XLSX files
4. **Wait for processing** — Documents are parsed, chunked, and embedded (status: processing → ready)
5. **Run analysis** — Click "Run Compliance Analysis" to assess all requirements against your documents
6. **Review results** — Dashboard shows scores, risk breakdown, and filterable results table
7. **Drill into evidence** — Click any requirement to see reasoning, evidence quotes, and recommendations
8. **Export reports** — Generate PDF, Excel, or JSON compliance reports

## API Endpoints

### Express (port 3001)

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/health` | Health check (+ Python service status) |
| POST | `/api/auth/signup` | Register |
| POST | `/api/auth/login` | Login |
| GET | `/api/projects` | List projects |
| POST | `/api/projects` | Create project |
| POST | `/api/documents/upload/:projectId` | Upload documents |
| POST | `/api/analysis/start/:projectId` | Start compliance analysis |
| GET | `/api/analysis/status/:projectId` | Analysis progress |
| GET | `/api/analysis/results/:projectId` | Compliance results |
| GET | `/api/projects/:id/scores` | Scoring summary |
| POST | `/api/reports/generate/:projectId` | Generate report |
| GET | `/api/reports/download/:projectId/:type` | Download report |

### Python (port 8000, internal only)

| Method | Path | Description |
|--------|------|-------------|
| GET | `/health` | Health check |
| POST | `/extract` | Extract text chunks from document |
| POST | `/embed` | Generate embedding vectors |

Both Python endpoints require `X-Internal-Secret` header.

## Compliance Analysis Pipeline

For each requirement in the selected framework(s):

1. **Retrieval** — pgvector cosine similarity search finds top-5 most relevant document chunks
2. **Reasoning** — Claude assesses compliance with strict JSON output: status, confidence, evidence, reasoning, recommendation
3. **Scoring** — Pass=1, Partial=0.5, Fail=0, N/A excluded; risk levels from severity
4. **Storage** — Results saved to `compliance_results` with evidence JSON

## Project Structure

```
/client/                  React frontend
/server/                  Express API (orchestrator)
  /routes/                API route handlers
  /services/              llmService, pythonServiceClient, scoringEngine, reportService
  /jobs/                  complianceAnalysisJob
  /data/frameworks/       NIST.json, ASVS.json, SAMM.json
  /scripts/               seedFrameworks.js
/python-service/          FastAPI microservice
  /app/routers/           extract.py, embed.py
  /app/services/          pdf_parser, docx_parser, excel_parser, embedder, chunker
/supabase/migrations/     Database schema + pgvector setup
```

## Nice-to-Have (Stubbed)

- Multi-document comparison view
- Historical compliance trend dashboard
- Comments on requirement results (schema ready in `result_comments` table)
- Re-run assessment with diff (`/api/analysis/rerun/:projectId` endpoint exists)

## License

MIT

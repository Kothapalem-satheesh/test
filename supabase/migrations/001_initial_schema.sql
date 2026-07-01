-- Enable pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Profiles (extends Supabase Auth users)
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  full_name TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Projects
CREATE TABLE IF NOT EXISTS projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  selected_frameworks TEXT[] DEFAULT '{}',
  analysis_status TEXT DEFAULT 'idle' CHECK (analysis_status IN ('idle', 'running', 'completed', 'failed')),
  analysis_progress JSONB DEFAULT '{"current": 0, "total": 0, "message": ""}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Documents
CREATE TABLE IF NOT EXISTS documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  filename TEXT NOT NULL,
  storage_path TEXT NOT NULL,
  file_type TEXT NOT NULL,
  file_size BIGINT DEFAULT 0,
  status TEXT DEFAULT 'processing' CHECK (status IN ('processing', 'ready', 'failed')),
  error_message TEXT,
  uploaded_at TIMESTAMPTZ DEFAULT NOW()
);

-- Document chunks with embeddings (384 dims for all-MiniLM-L6-v2)
CREATE TABLE IF NOT EXISTS document_chunks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  document_id UUID NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  embedding vector(384),
  page_number INTEGER,
  section_title TEXT,
  chunk_index INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Frameworks
CREATE TABLE IF NOT EXISTS frameworks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  version TEXT
);

-- Requirements
CREATE TABLE IF NOT EXISTS requirements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  framework_id UUID NOT NULL REFERENCES frameworks(id) ON DELETE CASCADE,
  requirement_code TEXT NOT NULL,
  category TEXT,
  requirement_text TEXT NOT NULL,
  keywords TEXT[] DEFAULT '{}',
  expected_evidence TEXT,
  severity TEXT DEFAULT 'Medium' CHECK (severity IN ('Critical', 'High', 'Medium', 'Low')),
  recommendation_text TEXT,
  embedding vector(384),
  UNIQUE(framework_id, requirement_code)
);

-- Compliance results
CREATE TABLE IF NOT EXISTS compliance_results (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  requirement_id UUID NOT NULL REFERENCES requirements(id) ON DELETE CASCADE,
  status TEXT NOT NULL CHECK (status IN ('Pass', 'Partial', 'Fail', 'Not Applicable')),
  confidence INTEGER DEFAULT 0 CHECK (confidence >= 0 AND confidence <= 100),
  evidence JSONB DEFAULT '[]',
  reasoning TEXT,
  recommendation TEXT,
  risk_level TEXT CHECK (risk_level IN ('High', 'Medium', 'Low')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(project_id, requirement_id)
);

-- Reports
CREATE TABLE IF NOT EXISTS reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  generated_at TIMESTAMPTZ DEFAULT NOW(),
  file_url TEXT,
  report_type TEXT DEFAULT 'pdf' CHECK (report_type IN ('pdf', 'excel', 'json')),
  summary JSONB DEFAULT '{}'
);

-- Comments on compliance results (nice-to-have)
CREATE TABLE IF NOT EXISTS result_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  result_id UUID NOT NULL REFERENCES compliance_results(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_projects_user_id ON projects(user_id);
CREATE INDEX IF NOT EXISTS idx_documents_project_id ON documents(project_id);
CREATE INDEX IF NOT EXISTS idx_document_chunks_document_id ON document_chunks(document_id);
CREATE INDEX IF NOT EXISTS idx_requirements_framework_id ON requirements(framework_id);
CREATE INDEX IF NOT EXISTS idx_compliance_results_project_id ON compliance_results(project_id);
CREATE INDEX IF NOT EXISTS idx_compliance_results_requirement_id ON compliance_results(requirement_id);

-- Vector similarity search indexes (IVFFlat - create after seeding data for best results)
CREATE INDEX IF NOT EXISTS idx_document_chunks_embedding ON document_chunks
  USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);
CREATE INDEX IF NOT EXISTS idx_requirements_embedding ON requirements
  USING ivfflat (embedding vector_cosine_ops) WITH (lists = 50);

-- RPC: match document chunks by embedding similarity
CREATE OR REPLACE FUNCTION match_document_chunks(
  query_embedding vector(384),
  match_project_id UUID,
  match_count INT DEFAULT 5
)
RETURNS TABLE (
  id UUID,
  document_id UUID,
  content TEXT,
  page_number INTEGER,
  section_title TEXT,
  similarity FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    dc.id,
    dc.document_id,
    dc.content,
    dc.page_number,
    dc.section_title,
    1 - (dc.embedding <=> query_embedding) AS similarity
  FROM document_chunks dc
  JOIN documents d ON d.id = dc.document_id
  WHERE d.project_id = match_project_id
    AND d.status = 'ready'
    AND dc.embedding IS NOT NULL
  ORDER BY dc.embedding <=> query_embedding
  LIMIT match_count;
END;
$$;

-- Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE document_chunks ENABLE ROW LEVEL SECURITY;
ALTER TABLE compliance_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE result_comments ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can view own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- Projects policies
CREATE POLICY "Users can view own projects" ON projects FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can create own projects" ON projects FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own projects" ON projects FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own projects" ON projects FOR DELETE USING (auth.uid() = user_id);

-- Documents policies (via project ownership)
CREATE POLICY "Users can view own documents" ON documents FOR SELECT
  USING (EXISTS (SELECT 1 FROM projects p WHERE p.id = documents.project_id AND p.user_id = auth.uid()));
CREATE POLICY "Users can insert own documents" ON documents FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM projects p WHERE p.id = documents.project_id AND p.user_id = auth.uid()));
CREATE POLICY "Users can update own documents" ON documents FOR UPDATE
  USING (EXISTS (SELECT 1 FROM projects p WHERE p.id = documents.project_id AND p.user_id = auth.uid()));
CREATE POLICY "Users can delete own documents" ON documents FOR DELETE
  USING (EXISTS (SELECT 1 FROM projects p WHERE p.id = documents.project_id AND p.user_id = auth.uid()));

-- Document chunks policies
CREATE POLICY "Users can view own chunks" ON document_chunks FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM documents d JOIN projects p ON p.id = d.project_id
    WHERE d.id = document_chunks.document_id AND p.user_id = auth.uid()
  ));

-- Compliance results policies
CREATE POLICY "Users can view own results" ON compliance_results FOR SELECT
  USING (EXISTS (SELECT 1 FROM projects p WHERE p.id = compliance_results.project_id AND p.user_id = auth.uid()));

-- Reports policies
CREATE POLICY "Users can view own reports" ON reports FOR SELECT
  USING (EXISTS (SELECT 1 FROM projects p WHERE p.id = reports.project_id AND p.user_id = auth.uid()));

-- Frameworks and requirements are public read
ALTER TABLE frameworks ENABLE ROW LEVEL SECURITY;
ALTER TABLE requirements ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read frameworks" ON frameworks FOR SELECT USING (true);
CREATE POLICY "Anyone can read requirements" ON requirements FOR SELECT USING (true);

-- Storage bucket policy (run in Supabase dashboard or via API)
-- Bucket name: documents

-- Auto-create profile on signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, email, full_name)
  VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'full_name');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

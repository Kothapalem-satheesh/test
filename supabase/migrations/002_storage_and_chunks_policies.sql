-- Additional policies for user-scoped document upload (no service role required)
-- Run this in Supabase SQL Editor if you already ran 001_initial_schema.sql

-- Document chunks: allow insert/update for project owners
CREATE POLICY "Users can insert own chunks" ON document_chunks FOR INSERT
  WITH CHECK (EXISTS (
    SELECT 1 FROM documents d JOIN projects p ON p.id = d.project_id
    WHERE d.id = document_chunks.document_id AND p.user_id = auth.uid()
  ));

CREATE POLICY "Users can update own chunks" ON document_chunks FOR UPDATE
  USING (EXISTS (
    SELECT 1 FROM documents d JOIN projects p ON p.id = d.project_id
    WHERE d.id = document_chunks.document_id AND p.user_id = auth.uid()
  ));

-- Storage bucket (create if missing)
INSERT INTO storage.buckets (id, name, public)
VALUES ('documents', 'documents', false)
ON CONFLICT (id) DO NOTHING;

-- Storage policies: users can manage files in their project folders
CREATE POLICY "Users can upload project documents" ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'documents'
    AND (storage.foldername(name))[1] IN (
      SELECT id::text FROM projects WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can read project documents" ON storage.objects FOR SELECT TO authenticated
  USING (
    bucket_id = 'documents'
    AND (storage.foldername(name))[1] IN (
      SELECT id::text FROM projects WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete project documents" ON storage.objects FOR DELETE TO authenticated
  USING (
    bucket_id = 'documents'
    AND (storage.foldername(name))[1] IN (
      SELECT id::text FROM projects WHERE user_id = auth.uid()
    )
  );

-- Compliance results: allow server/user to insert analysis results for own projects
CREATE POLICY "Users can insert own results" ON compliance_results FOR INSERT
  WITH CHECK (EXISTS (
    SELECT 1 FROM projects p WHERE p.id = compliance_results.project_id AND p.user_id = auth.uid()
  ));

CREATE POLICY "Users can update own results" ON compliance_results FOR UPDATE
  USING (EXISTS (
    SELECT 1 FROM projects p WHERE p.id = compliance_results.project_id AND p.user_id = auth.uid()
  ));

CREATE POLICY "Users can delete own results" ON compliance_results FOR DELETE
  USING (EXISTS (
    SELECT 1 FROM projects p WHERE p.id = compliance_results.project_id AND p.user_id = auth.uid()
  ));

-- Projects: allow analysis status updates
-- (already covered by update policy)

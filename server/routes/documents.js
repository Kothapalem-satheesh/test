import { Router } from 'express';
import multer from 'multer';
import { v4 as uuidv4 } from 'uuid';
import { authenticate } from '../middleware/auth.js';
import {
  supabaseAdmin,
  createUserClient,
  STORAGE_BUCKET,
  isServiceRoleConfigured,
} from '../config/supabase.js';
import { config } from '../config/index.js';
import { extractDocument, generateEmbeddings } from '../services/pythonServiceClient.js';

const router = Router();
router.use(authenticate);

const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: config.maxFileSizeMb * 1024 * 1024 },
  fileFilter: (req, file, cb) => {
    const ext = file.originalname.split('.').pop()?.toLowerCase();
    if (!config.allowedFileTypes.includes(ext)) {
      return cb(new Error(`File type .${ext} not allowed. Allowed: ${config.allowedFileTypes.join(', ')}`));
    }
    cb(null, true);
  },
});

/** Prefer service role for background jobs; fall back to user token */
function getDbClient(accessToken) {
  if (isServiceRoleConfigured && supabaseAdmin) return supabaseAdmin;
  return createUserClient(accessToken);
}

async function verifyProjectOwnership(supabase, projectId) {
  const { data } = await supabase
    .from('projects')
    .select('id')
    .eq('id', projectId)
    .single();
  return data;
}

router.get('/project/:projectId', async (req, res, next) => {
  try {
    const project = await verifyProjectOwnership(req.supabase, req.params.projectId);
    if (!project) return res.status(404).json({ error: 'Project not found' });

    const { data, error } = await req.supabase
      .from('documents')
      .select('*')
      .eq('project_id', req.params.projectId)
      .order('uploaded_at', { ascending: false });

    if (error) throw error;
    res.json(data);
  } catch (err) {
    next(err);
  }
});

router.post('/upload/:projectId', upload.array('files', 10), async (req, res, next) => {
  try {
    const project = await verifyProjectOwnership(req.supabase, req.params.projectId);
    if (!project) return res.status(404).json({ error: 'Project not found' });

    if (!req.files?.length) {
      return res.status(400).json({ error: 'No files uploaded' });
    }

    const results = [];
    const accessToken = req.accessToken;

    for (const file of req.files) {
      const ext = file.originalname.split('.').pop()?.toLowerCase();
      const docId = uuidv4();
      const storagePath = `${req.params.projectId}/${docId}.${ext}`;

      const { error: uploadError } = await req.supabase.storage
        .from(STORAGE_BUCKET)
        .upload(storagePath, file.buffer, {
          contentType: file.mimetype,
          upsert: false,
        });

      if (uploadError) {
        results.push({
          filename: file.originalname,
          status: 'failed',
          error: uploadError.message || 'Storage upload failed. Run migration 002 in Supabase SQL Editor.',
        });
        continue;
      }

      const { data: doc, error: docError } = await req.supabase
        .from('documents')
        .insert({
          id: docId,
          project_id: req.params.projectId,
          filename: file.originalname,
          storage_path: storagePath,
          file_type: ext,
          file_size: file.size,
          status: 'processing',
        })
        .select()
        .single();

      if (docError) {
        results.push({ filename: file.originalname, status: 'failed', error: docError.message });
        continue;
      }

      processDocument(doc, file.buffer, ext, accessToken).catch((err) => {
        console.error(`Document processing failed for ${doc.id}:`, err.message);
      });

      results.push({ id: doc.id, filename: file.originalname, status: 'processing' });
    }

    res.status(201).json({ documents: results });
  } catch (err) {
    next(err);
  }
});

async function processDocument(doc, fileBuffer, fileType, accessToken) {
  const db = getDbClient(accessToken);

  try {
    const extractResult = await extractDocument(fileBuffer, doc.filename, fileType);
    const chunks = extractResult.chunks || [];

    if (!chunks.length) {
      await db
        .from('documents')
        .update({ status: 'failed', error_message: 'No text extracted from document' })
        .eq('id', doc.id);
      return;
    }

    const texts = chunks.map((c) => c.content);
    const embedResult = await generateEmbeddings(texts);
    const embeddings = embedResult.embeddings || [];

    const chunkRows = chunks.map((chunk, i) => ({
      document_id: doc.id,
      content: chunk.content,
      embedding: embeddings[i] || null,
      page_number: chunk.page_number,
      section_title: chunk.section_title,
      chunk_index: i,
    }));

    const { error: chunkError } = await db.from('document_chunks').insert(chunkRows);
    if (chunkError) throw chunkError;

    await db.from('documents').update({ status: 'ready' }).eq('id', doc.id);

    console.log(`Document ${doc.id} processed: ${chunks.length} chunks`);
  } catch (err) {
    await db
      .from('documents')
      .update({ status: 'failed', error_message: err.message })
      .eq('id', doc.id);
    throw err;
  }
}

router.get('/:id/chunks', async (req, res, next) => {
  try {
    const { data: doc, error: docError } = await req.supabase
      .from('documents')
      .select('id')
      .eq('id', req.params.id)
      .single();

    if (docError || !doc) {
      return res.status(404).json({ error: 'Document not found' });
    }

    const { data, error } = await req.supabase
      .from('document_chunks')
      .select('id, content, page_number, section_title, chunk_index')
      .eq('document_id', req.params.id)
      .order('chunk_index');

    if (error) throw error;
    res.json(data);
  } catch (err) {
    next(err);
  }
});

router.post('/:id/reprocess', async (req, res, next) => {
  try {
    const { data: doc, error: docError } = await req.supabase
      .from('documents')
      .select('*')
      .eq('id', req.params.id)
      .single();

    if (docError || !doc) {
      return res.status(404).json({ error: 'Document not found' });
    }

    if (doc.status === 'processing') {
      return res.status(409).json({ error: 'Document is already being processed' });
    }

    const { data: fileData, error: downloadError } = await req.supabase.storage
      .from(STORAGE_BUCKET)
      .download(doc.storage_path);

    if (downloadError) {
      return res.status(500).json({ error: downloadError.message || 'Failed to download document' });
    }

    const buffer = Buffer.from(await fileData.arrayBuffer());

    await req.supabase.from('document_chunks').delete().eq('document_id', doc.id);
    await req.supabase
      .from('documents')
      .update({ status: 'processing', error_message: null })
      .eq('id', doc.id);

    processDocument(doc, buffer, doc.file_type, req.accessToken).catch((err) => {
      console.error(`Document reprocess failed for ${doc.id}:`, err.message);
    });

    res.json({ id: doc.id, status: 'processing', message: 'Reprocessing with updated NLP pipeline' });
  } catch (err) {
    next(err);
  }
});

router.delete('/:id', async (req, res, next) => {
  try {
    const { data: doc, error: docError } = await req.supabase
      .from('documents')
      .select('id, storage_path')
      .eq('id', req.params.id)
      .single();

    if (docError || !doc) {
      return res.status(404).json({ error: 'Document not found' });
    }

    await req.supabase.storage.from(STORAGE_BUCKET).remove([doc.storage_path]);
    await req.supabase.from('documents').delete().eq('id', req.params.id);

    res.json({ message: 'Document deleted' });
  } catch (err) {
    next(err);
  }
});

export default router;

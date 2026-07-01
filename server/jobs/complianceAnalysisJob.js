import {
  supabaseAdmin,
  supabasePublic,
  createUserClient,
  isServiceRoleConfigured,
} from '../config/supabase.js';
import { config } from '../config/index.js';
import { generateEmbeddings } from '../services/pythonServiceClient.js';
import { assessCompliance } from '../services/llmService.js';
import { getRiskLevel } from '../services/scoringEngine.js';
import { rankAndFilterChunks, keywordFallbackChunks } from '../services/retrievalService.js';

const activeJobs = new Map();

function getDb(accessToken) {
  if (isServiceRoleConfigured && supabaseAdmin) return supabaseAdmin;
  return createUserClient(accessToken);
}

export async function runComplianceAnalysis(projectId, frameworkIds, accessToken) {
  if (activeJobs.has(projectId)) {
    throw new Error('Analysis already running for this project');
  }

  const db = getDb(accessToken);
  activeJobs.set(projectId, { status: 'running', startedAt: Date.now() });

  try {
    await updateProjectStatus(db, projectId, 'running', { current: 0, total: 0, message: 'Starting analysis...' });
    await db.from('compliance_results').delete().eq('project_id', projectId);

    let query = supabasePublic
      .from('requirements')
      .select('*, framework:frameworks(id, name)');

    if (frameworkIds?.length > 0) {
      query = query.in('framework_id', frameworkIds);
    }

    const { data: requirements, error: reqError } = await query;
    if (reqError) throw reqError;
    if (!requirements?.length) {
      throw new Error('No frameworks loaded. Run migrations 004 and 005 in Supabase SQL Editor.');
    }

    const total = requirements.length;
    let completed = 0;

    const { data: documents } = await db
      .from('documents')
      .select('id, filename')
      .eq('project_id', projectId)
      .eq('status', 'ready');

    const documentMap = Object.fromEntries((documents || []).map((d) => [d.id, d.filename]));

    await updateProjectStatus(db, projectId, 'running', {
      current: 0,
      total,
      message: `Analyzing ${total} requirements (${config.analysisConcurrency} parallel)...`,
    });

    const assessOne = async (req) => {
      const frameworkName = req.framework?.name || 'Unknown';

      try {
        const embedding = await getRequirementEmbedding(req, db);
        let chunks = [];

        if (embedding) {
          const raw = await retrieveSimilarChunks(db, projectId, embedding, config.topKChunks * 2);
          chunks = rankAndFilterChunks(raw, req, {
            similarityThreshold: config.similarityThreshold,
            topK: config.topKChunks,
          });
        }

        if (!chunks.length) {
          chunks = await keywordFallbackChunks(db, projectId, req, config.topKChunks);
        }

        const assessment = await assessCompliance(
          { ...req, framework_name: frameworkName },
          chunks,
          documentMap
        );

        await db.from('compliance_results').upsert({
          project_id: projectId,
          requirement_id: req.id,
          status: assessment.status,
          confidence: assessment.confidence,
          evidence: assessment.evidence,
          reasoning: assessment.reasoning,
          recommendation: assessment.recommendation || req.recommendation_text,
          risk_level: getRiskLevel(assessment.status, req.severity),
        }, { onConflict: 'project_id,requirement_id' });
      } catch (reqErr) {
        console.error(`Error assessing ${req.requirement_code}:`, reqErr.message);
        await db.from('compliance_results').upsert({
          project_id: projectId,
          requirement_id: req.id,
          status: 'Fail',
          confidence: 0,
          evidence: [],
          reasoning: `Analysis error: ${reqErr.message}`,
          recommendation: req.recommendation_text,
          risk_level: getRiskLevel('Fail', req.severity),
        }, { onConflict: 'project_id,requirement_id' });
      } finally {
        completed += 1;
        await updateProjectStatus(db, projectId, 'running', {
          current: completed,
          total,
          message: `Assessed ${completed}/${total} requirements`,
        });
      }
    };

    let nextIndex = 0;
    const workers = Array.from(
      { length: Math.min(config.analysisConcurrency, total) },
      async () => {
        while (nextIndex < total) {
          const i = nextIndex;
          nextIndex += 1;
          await assessOne(requirements[i]);
        }
      }
    );
    await Promise.all(workers);

    await updateProjectStatus(db, projectId, 'completed', {
      current: total,
      total,
      message: 'Analysis complete',
    });

    return { success: true, total };
  } catch (err) {
    await updateProjectStatus(db, projectId, 'failed', {
      current: 0,
      total: 0,
      message: err.message,
    });
    throw err;
  } finally {
    activeJobs.delete(projectId);
  }
}

async function getRequirementEmbedding(req, db) {
  if (req.embedding) return req.embedding;

  const text = [
    req.requirement_code,
    req.requirement_text,
    req.category,
    `Keywords: ${(req.keywords || []).join(', ')}`,
    req.expected_evidence || '',
  ].filter(Boolean).join('. ');

  const result = await generateEmbeddings([text]);
  const embedding = result.embeddings?.[0];
  if (!embedding) return null;

  if (isServiceRoleConfigured && supabaseAdmin) {
    await supabaseAdmin.from('requirements').update({ embedding }).eq('id', req.id);
  }
  return embedding;
}

async function retrieveSimilarChunks(db, projectId, requirementEmbedding, topK) {
  const { data, error } = await db.rpc('match_document_chunks', {
    query_embedding: requirementEmbedding,
    match_project_id: projectId,
    match_count: topK,
  });

  if (error) {
    console.error('Vector search error:', error.message);
    return [];
  }
  return data || [];
}

async function updateProjectStatus(db, projectId, status, progress) {
  await db
    .from('projects')
    .update({
      analysis_status: status,
      analysis_progress: progress,
      updated_at: new Date().toISOString(),
    })
    .eq('id', projectId);
}

export function getJobStatus(projectId) {
  return activeJobs.get(projectId) || null;
}

export function isAnalysisRunning(projectId) {
  return activeJobs.has(projectId);
}

export default { runComplianceAnalysis, getJobStatus, isAnalysisRunning };

import { Router } from 'express';
import { authenticate } from '../middleware/auth.js';
import { supabasePublic } from '../config/supabase.js';
import { runComplianceAnalysis, isAnalysisRunning } from '../jobs/complianceAnalysisJob.js';

const router = Router();
router.use(authenticate);

async function verifyProject(supabase, projectId) {
  const { data } = await supabase
    .from('projects')
    .select('*')
    .eq('id', projectId)
    .single();
  return data;
}

router.post('/start/:projectId', async (req, res, next) => {
  try {
    const project = await verifyProject(req.supabase, req.params.projectId);
    if (!project) return res.status(404).json({ error: 'Project not found' });

    if (isAnalysisRunning(req.params.projectId)) {
      return res.status(409).json({ error: 'Analysis already in progress' });
    }

    const { data: docs } = await req.supabase
      .from('documents')
      .select('id, status')
      .eq('project_id', req.params.projectId);

    const readyDocs = (docs || []).filter((d) => d.status === 'ready');
    if (!readyDocs.length) {
      return res.status(400).json({ error: 'No processed documents available. Upload documents first.' });
    }

    let frameworkIds = req.body.framework_ids || [];
    if (!frameworkIds.length && project.selected_frameworks?.length) {
      const { data: fws } = await supabasePublic
        .from('frameworks')
        .select('id, name')
        .in('name', project.selected_frameworks);
      frameworkIds = (fws || []).map((f) => f.id);
    }

    runComplianceAnalysis(req.params.projectId, frameworkIds, req.accessToken).catch((err) => {
      console.error('Background analysis failed:', err.message);
    });

    res.json({ message: 'Analysis started', project_id: req.params.projectId, frameworks: frameworkIds.length });
  } catch (err) {
    next(err);
  }
});

router.get('/status/:projectId', async (req, res, next) => {
  try {
    const project = await verifyProject(req.supabase, req.params.projectId);
    if (!project) return res.status(404).json({ error: 'Project not found' });

    res.json({
      status: project.analysis_status,
      progress: project.analysis_progress,
      running: isAnalysisRunning(req.params.projectId),
    });
  } catch (err) {
    next(err);
  }
});

router.get('/results/:projectId', async (req, res, next) => {
  try {
    const project = await verifyProject(req.supabase, req.params.projectId);
    if (!project) return res.status(404).json({ error: 'Project not found' });

    const { status, framework, severity, sort = 'requirement_code' } = req.query;

    const { data, error } = await req.supabase
      .from('compliance_results')
      .select('*, requirement:requirements(*, framework:frameworks(name))')
      .eq('project_id', req.params.projectId);

    if (error) throw error;

    let filtered = data || [];

    if (status) filtered = filtered.filter((r) => r.status === status);
    if (framework) filtered = filtered.filter((r) => r.requirement?.framework?.name === framework);
    if (severity) filtered = filtered.filter((r) => r.requirement?.severity === severity);

    filtered.sort((a, b) => {
      if (sort === 'status') return a.status.localeCompare(b.status);
      if (sort === 'severity') {
        const order = { Critical: 0, High: 1, Medium: 2, Low: 3 };
        return (order[a.requirement?.severity] || 2) - (order[b.requirement?.severity] || 2);
      }
      return (a.requirement?.requirement_code || '').localeCompare(b.requirement?.requirement_code || '');
    });

    res.json(filtered);
  } catch (err) {
    next(err);
  }
});

router.get('/result/:resultId', async (req, res, next) => {
  try {
    const { data, error } = await req.supabase
      .from('compliance_results')
      .select('*, requirement:requirements(*, framework:frameworks(name)), project:projects(user_id)')
      .eq('id', req.params.resultId)
      .single();

    if (error || !data || data.project?.user_id !== req.user.id) {
      return res.status(404).json({ error: 'Result not found' });
    }

    res.json(data);
  } catch (err) {
    next(err);
  }
});

router.post('/rerun/:projectId', async (req, res, next) => {
  try {
    const project = await verifyProject(req.supabase, req.params.projectId);
    if (!project) return res.status(404).json({ error: 'Project not found' });

    const { data: previousResults } = await req.supabase
      .from('compliance_results')
      .select('*')
      .eq('project_id', req.params.projectId);

    let frameworkIds = req.body.framework_ids || [];
    if (!frameworkIds.length && project.selected_frameworks?.length) {
      const { data: fws } = await supabasePublic
        .from('frameworks')
        .select('id')
        .in('name', project.selected_frameworks);
      frameworkIds = (fws || []).map((f) => f.id);
    }

    runComplianceAnalysis(req.params.projectId, frameworkIds, req.accessToken).catch(console.error);

    res.json({
      message: 'Re-analysis started',
      previous_count: previousResults?.length || 0,
    });
  } catch (err) {
    next(err);
  }
});

export default router;

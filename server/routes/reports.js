import { Router } from 'express';

import { authenticate } from '../middleware/auth.js';

import { supabaseAdmin, isServiceRoleConfigured } from '../config/supabase.js';

import { calculateScores } from '../services/scoringEngine.js';

import {

  generatePdfReport,

  generateExcelReport,

  generateJsonReport,

  saveReport,

} from '../services/reportService.js';



const router = Router();

router.use(authenticate);



async function getProjectResults(supabase, projectId) {

  const { data: project, error: projectError } = await supabase

    .from('projects')

    .select('*')

    .eq('id', projectId)

    .single();



  if (projectError || !project) return null;



  const [{ data: results, error: resultsError }, { data: documents, error: docsError }] = await Promise.all([

    supabase

      .from('compliance_results')

      .select('*, requirement:requirements(*, framework:frameworks(name))')

      .eq('project_id', projectId),

    supabase

      .from('documents')

      .select('filename, file_type, file_size, status')

      .eq('project_id', projectId)

      .order('uploaded_at'),

  ]);



  if (resultsError) throw resultsError;

  if (docsError) throw docsError;



  return { project, results: results || [], documents: documents || [] };

}



function sendReportFile(res, type, project, buffer) {

  const safeName = (project.name || 'report').replace(/[^\w.-]+/g, '-');

  if (type === 'json') {

    res.setHeader('Content-Type', 'application/json');

    res.setHeader('Content-Disposition', `attachment; filename="compliance-report-${safeName}.json"`);

    return res.send(typeof buffer === 'string' ? buffer : buffer.toString());

  }

  if (type === 'excel') {

    res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

    res.setHeader('Content-Disposition', `attachment; filename="compliance-report-${safeName}.xlsx"`);

    return res.send(Buffer.from(buffer));

  }

  res.setHeader('Content-Type', 'application/pdf');

  res.setHeader('Content-Disposition', `attachment; filename="compliance-report-${safeName}.pdf"`);

  return res.send(buffer);

}



router.post('/generate/:projectId', async (req, res, next) => {

  try {

    const { type = 'pdf' } = req.body;

    const data = await getProjectResults(req.supabase, req.params.projectId);

    if (!data) return res.status(404).json({ error: 'Project not found' });



    const { project, results, documents } = data;

    if (!results.length) {

      return res.status(400).json({ error: 'No compliance results. Run analysis first.' });

    }



    const scores = calculateScores(results);



    if (type === 'json') {

      const jsonReport = generateJsonReport(project, results, scores, documents);

      const buffer = Buffer.from(JSON.stringify(jsonReport, null, 2));

      if (isServiceRoleConfigured) {

        const report = await saveReport(project.id, buffer, 'json', scores);

        return res.json({ report, data: jsonReport });

      }

      return res.json({ data: jsonReport });

    }



    if (type === 'excel') {

      const buffer = await generateExcelReport(project, results, scores);

      if (isServiceRoleConfigured) {

        const report = await saveReport(project.id, Buffer.from(buffer), 'excel', scores);

        return res.json({ report, download_url: report.file_url });

      }

      return sendReportFile(res, 'excel', project, buffer);

    }



    const pdfBuffer = await generatePdfReport(project, results, scores, documents);

    if (isServiceRoleConfigured) {

      const report = await saveReport(project.id, pdfBuffer, 'pdf', scores);

      return res.json({ report, download_url: report.file_url });

    }

    return sendReportFile(res, 'pdf', project, pdfBuffer);

  } catch (err) {

    next(err);

  }

});



router.get('/download/:projectId/:type', async (req, res, next) => {

  try {

    const { type } = req.params;

    const data = await getProjectResults(req.supabase, req.params.projectId);

    if (!data) return res.status(404).json({ error: 'Project not found' });



    const { project, results, documents } = data;

    if (!results.length) {

      return res.status(400).json({ error: 'No compliance results. Run analysis first.' });

    }



    const scores = calculateScores(results);



    if (type === 'json') {

      const jsonReport = generateJsonReport(project, results, scores, documents);

      return sendReportFile(res, 'json', project, JSON.stringify(jsonReport, null, 2));

    }



    if (type === 'excel') {

      const buffer = await generateExcelReport(project, results, scores);

      return sendReportFile(res, 'excel', project, buffer);

    }



    const pdfBuffer = await generatePdfReport(project, results, scores, documents);

    return sendReportFile(res, 'pdf', project, pdfBuffer);

  } catch (err) {

    next(err);

  }

});



router.get('/history/:projectId', async (req, res, next) => {

  try {

    if (!isServiceRoleConfigured) {

      return res.json([]);

    }



    const { data: project } = await req.supabase

      .from('projects')

      .select('id')

      .eq('id', req.params.projectId)

      .single();



    if (!project) return res.status(404).json({ error: 'Project not found' });



    const { data, error } = await supabaseAdmin

      .from('reports')

      .select('*')

      .eq('project_id', req.params.projectId)

      .order('generated_at', { ascending: false });



    if (error) throw error;

    res.json(data);

  } catch (err) {

    next(err);

  }

});



export default router;


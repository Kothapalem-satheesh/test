import PDFDocument from 'pdfkit';

import ExcelJS from 'exceljs';

import { supabaseAdmin, STORAGE_BUCKET } from '../config/supabase.js';

import { calculateScores } from './scoringEngine.js';



function addSectionTitle(doc, title) {

  if (doc.y > 680) doc.addPage();

  doc.fontSize(16).fillColor('#111827').text(title, { underline: true });

  doc.moveDown(0.5);

  doc.fontSize(10).fillColor('#374151');

}



function addParagraph(doc, text, options = {}) {

  doc.text(text, { lineGap: 3, ...options });

  doc.moveDown(0.3);

}



function statusSymbol(status) {

  if (status === 'Pass') return '[PASS]';

  if (status === 'Partial') return '[PARTIAL]';

  if (status === 'Fail') return '[FAIL]';

  return '[N/A]';

}



/**

 * Generate PDF compliance report

 */

export async function generatePdfReport(project, results, scores, documents = []) {

  return new Promise((resolve, reject) => {

    const chunks = [];

    const doc = new PDFDocument({ margin: 50, size: 'A4' });



    doc.on('data', (chunk) => chunks.push(chunk));

    doc.on('end', () => resolve(Buffer.concat(chunks)));

    doc.on('error', reject);



    const frameworks = project.selected_frameworks?.length

      ? project.selected_frameworks

      : [...new Set(results.map((r) => r.requirement?.framework?.name).filter(Boolean))];



    // Title page

    doc.fontSize(26).fillColor('#1e40af').text('Compliance Assessment Report', { align: 'center' });

    doc.moveDown(0.5);

    doc.fontSize(16).fillColor('#111827').text(project.name, { align: 'center' });

    doc.moveDown(0.3);

    doc.fontSize(10).fillColor('#6b7280').text(`Generated: ${new Date().toLocaleString()}`, { align: 'center' });

    doc.moveDown(2);



    // Table of contents

    doc.fontSize(14).fillColor('#111827').text('Contents', { underline: true });

    doc.moveDown(0.5);

    doc.fontSize(10).fillColor('#374151');

    const toc = [

      '1. Assessment Overview & Methodology',

      '2. Documents Assessed',

      '3. Frameworks & Scope',

      '4. Executive Summary',

      '5. Framework Scores',

      '6. Gaps & Failures',

      '7. Full Compliance Checklist',

      '8. Evidence Appendix (Document-to-Policy Mapping)',

    ];

    toc.forEach((line) => doc.text(line));

    doc.moveDown(1.5);



    // Section 1: Methodology

    doc.addPage();

    addSectionTitle(doc, '1. Assessment Overview & Methodology');

    addParagraph(doc, 'This report documents how uploaded organizational documents were compared against selected compliance framework requirements.');

    addParagraph(doc, 'Assessment process:');

    [

      'Documents were parsed, chunked, and indexed for semantic search.',

      'Each requirement in the selected frameworks was evaluated individually.',

      'Relevant passages from uploaded documents were retrieved as evidence.',

      'An AI model assessed whether the evidence satisfies each requirement.',

      'Each requirement received a status: Pass (fully met), Partial (partially met), or Fail (not met or no evidence).',

    ].forEach((step, i) => addParagraph(doc, `  ${i + 1}. ${step}`));

    addParagraph(doc, 'Status definitions:');

    addParagraph(doc, '  Pass — Document evidence clearly addresses the requirement.');

    addParagraph(doc, '  Partial — Some relevant content exists but gaps remain.');

    addParagraph(doc, '  Fail — No adequate evidence found in uploaded documents.');

    addParagraph(doc, '  Not Applicable — Requirement does not apply to this organization.');



    // Section 2: Documents

    addSectionTitle(doc, '2. Documents Assessed');

    if (documents.length === 0) {

      addParagraph(doc, 'No document metadata available.');

    } else {

      documents.forEach((d, i) => {

        addParagraph(doc, `  ${i + 1}. ${d.filename} (${d.file_type?.toUpperCase() || 'unknown'}, ${((d.file_size || 0) / 1024).toFixed(1)} KB) — ${d.status || 'unknown'}`);

      });

    }



    // Section 3: Frameworks

    addSectionTitle(doc, '3. Frameworks & Scope');

    if (frameworks.length === 0) {

      addParagraph(doc, 'All seeded framework requirements were assessed.');

    } else {

      addParagraph(doc, `The following ${frameworks.length} framework(s) were in scope:`);

      frameworks.forEach((fw, i) => addParagraph(doc, `  ${i + 1}. ${fw}`));

    }

    addParagraph(doc, `Total requirements assessed: ${scores.totalResults}`);



    // Section 4: Executive Summary

    doc.addPage();

    addSectionTitle(doc, '4. Executive Summary');

    doc.fontSize(12).fillColor('#1e40af').text(`Overall Compliance Score: ${scores.overallPercentage}%`);

    doc.moveDown(0.5);

    doc.fontSize(10).fillColor('#374151');

    addParagraph(doc, `Total Requirements Assessed: ${scores.totalResults}`);

    addParagraph(doc, `High Risk Items: ${scores.riskSummary.High}`);

    addParagraph(doc, `Medium Risk Items: ${scores.riskSummary.Medium}`);

    addParagraph(doc, `Low Risk Items: ${scores.riskSummary.Low}`);



    const passCount = results.filter((r) => r.status === 'Pass').length;

    const partialCount = results.filter((r) => r.status === 'Partial').length;

    const failCount = results.filter((r) => r.status === 'Fail').length;

    addParagraph(doc, `Pass: ${passCount} | Partial: ${partialCount} | Fail: ${failCount}`);



    // Section 5: Framework Scores

    addSectionTitle(doc, '5. Framework Scores');

    for (const [name, fw] of Object.entries(scores.frameworkScores)) {

      addParagraph(doc, `${name}: ${fw.percentage}% — ${fw.pass} Pass, ${fw.partial} Partial, ${fw.fail} Fail`);

    }



    // Section 6: Failures

    if (scores.missingControls.length > 0) {

      doc.addPage();

      addSectionTitle(doc, '6. Gaps & Failures');

      addParagraph(doc, 'Requirements where documents did not adequately demonstrate compliance:');

      doc.moveDown(0.3);

      for (const ctrl of scores.missingControls) {

        if (doc.y > 700) doc.addPage();

        doc.fontSize(10).fillColor('#b91c1c').text(`[${ctrl.severity}] ${ctrl.requirement_code}`);

        doc.fontSize(9).fillColor('#374151').text(ctrl.requirement_text || '', { indent: 15 });

        if (ctrl.recommendation) {

          doc.fontSize(9).fillColor('#6b7280').text(`Remediation: ${ctrl.recommendation}`, { indent: 15 });

        }

        doc.moveDown(0.5);

      }

    }



    // Section 7: Full Checklist

    doc.addPage();

    addSectionTitle(doc, '7. Full Compliance Checklist');

    addParagraph(doc, 'Requirement-by-requirement assessment results. See Section 8 for document evidence quotes.');

    doc.moveDown(0.3);



    for (const result of results) {

      if (doc.y > 700) doc.addPage();

      const req = result.requirement || {};

      const fw = req.framework?.name || '';

      doc.fontSize(9).fillColor('#111827').text(

        `${statusSymbol(result.status)} ${fw} | ${req.requirement_code} | Confidence: ${result.confidence}% | Risk: ${result.risk_level || 'N/A'}`

      );

      doc.fontSize(8).fillColor('#4b5563').text(req.requirement_text || '', { indent: 10 });

      if (result.reasoning) {

        doc.fontSize(8).fillColor('#6b7280').text(`Assessment: ${result.reasoning}`, { indent: 10 });

      }

      if (result.recommendation && result.status !== 'Pass') {

        doc.fontSize(8).fillColor('#92400e').text(`Recommendation: ${result.recommendation}`, { indent: 10 });

      }

      doc.moveDown(0.4);

    }



    // Section 8: Evidence Appendix

    doc.addPage();

    addSectionTitle(doc, '8. Evidence Appendix (Document-to-Policy Mapping)');

    addParagraph(doc, 'For each requirement, the following passages from your uploaded documents were used as evidence during assessment.');

    doc.moveDown(0.3);



    const withEvidence = results.filter((r) => r.evidence?.length > 0);

    if (withEvidence.length === 0) {

      addParagraph(doc, 'No document evidence was matched to requirements.');

    }



    for (const result of withEvidence) {

      if (doc.y > 680) doc.addPage();

      const req = result.requirement || {};

      doc.fontSize(10).fillColor('#1e40af').text(`${req.requirement_code} — ${statusSymbol(result.status)}`);

      doc.fontSize(8).fillColor('#4b5563').text(req.requirement_text?.substring(0, 200) || '', { indent: 10 });

      doc.moveDown(0.2);

      for (const ev of result.evidence) {

        if (doc.y > 720) doc.addPage();

        doc.fontSize(8).fillColor('#374151').text(

          `Source: ${ev.source_document || 'Document'} | Location: ${ev.page_or_section || 'N/A'}`,

          { indent: 15 }

        );

        doc.fontSize(8).fillColor('#111827').text(`"${ev.text || ''}"`, { indent: 20 });

        doc.moveDown(0.2);

      }

      doc.moveDown(0.4);

    }



    doc.end();

  });

}



/**

 * Generate Excel compliance report

 */

export async function generateExcelReport(project, results, scores) {

  const workbook = new ExcelJS.Workbook();

  workbook.creator = 'ComplianceAI';

  workbook.created = new Date();



  // Summary sheet

  const summary = workbook.addWorksheet('Summary');

  summary.columns = [

    { header: 'Metric', key: 'metric', width: 30 },

    { header: 'Value', key: 'value', width: 20 },

  ];

  summary.addRow({ metric: 'Project', value: project.name });

  summary.addRow({ metric: 'Overall Score', value: `${scores.overallPercentage}%` });

  summary.addRow({ metric: 'High Risk', value: scores.riskSummary.High });

  summary.addRow({ metric: 'Medium Risk', value: scores.riskSummary.Medium });

  summary.addRow({ metric: 'Low Risk', value: scores.riskSummary.Low });



  for (const [name, fw] of Object.entries(scores.frameworkScores)) {

    summary.addRow({ metric: `${name} Score`, value: `${fw.percentage}%` });

  }



  // Results sheet

  const resultsSheet = workbook.addWorksheet('Results');

  resultsSheet.columns = [

    { header: 'Framework', key: 'framework', width: 15 },

    { header: 'Code', key: 'code', width: 12 },

    { header: 'Category', key: 'category', width: 20 },

    { header: 'Status', key: 'status', width: 12 },

    { header: 'Confidence', key: 'confidence', width: 12 },

    { header: 'Severity', key: 'severity', width: 12 },

    { header: 'Risk Level', key: 'risk', width: 12 },

    { header: 'Requirement', key: 'requirement', width: 50 },

    { header: 'Evidence Sources', key: 'evidence_sources', width: 40 },

    { header: 'Reasoning', key: 'reasoning', width: 60 },

    { header: 'Recommendation', key: 'recommendation', width: 60 },

  ];



  for (const result of results) {

    const req = result.requirement || {};

    const evidenceSources = (result.evidence || [])

      .map((ev) => `${ev.source_document || 'Doc'}: "${(ev.text || '').substring(0, 100)}..."`)

      .join(' | ');

    resultsSheet.addRow({

      framework: req.framework?.name || '',

      code: req.requirement_code,

      category: req.category,

      status: result.status,

      confidence: result.confidence,

      severity: req.severity,

      risk: result.risk_level,

      requirement: req.requirement_text,

      evidence_sources: evidenceSources,

      reasoning: result.reasoning,

      recommendation: result.recommendation,

    });

  }



  // Missing controls sheet

  const missing = workbook.addWorksheet('Missing Controls');

  missing.columns = [

    { header: 'Code', key: 'code', width: 12 },

    { header: 'Severity', key: 'severity', width: 12 },

    { header: 'Requirement', key: 'requirement', width: 50 },

    { header: 'Recommendation', key: 'recommendation', width: 60 },

  ];

  for (const ctrl of scores.missingControls) {

    missing.addRow({

      code: ctrl.requirement_code,

      severity: ctrl.severity,

      requirement: ctrl.requirement_text,

      recommendation: ctrl.recommendation,

    });

  }



  return workbook.xlsx.writeBuffer();

}



/**

 * Generate JSON export

 */

export function generateJsonReport(project, results, scores, documents = []) {

  return {

    project: {

      id: project.id,

      name: project.name,

      created_at: project.created_at,

      selected_frameworks: project.selected_frameworks,

    },

    documents_assessed: documents.map((d) => ({

      filename: d.filename,

      file_type: d.file_type,

      status: d.status,

    })),

    generated_at: new Date().toISOString(),

    methodology: 'Semantic search over document chunks + AI assessment per requirement',

    scores,

    results: results.map((r) => ({

      requirement_code: r.requirement?.requirement_code,

      framework: r.requirement?.framework?.name,

      category: r.requirement?.category,

      status: r.status,

      confidence: r.confidence,

      evidence: r.evidence,

      reasoning: r.reasoning,

      recommendation: r.recommendation,

      risk_level: r.risk_level,

    })),

  };

}



/**

 * Upload report to Supabase Storage and save record

 */

export async function saveReport(projectId, buffer, type, summary) {

  const filename = `report-${projectId}-${Date.now()}.${type === 'excel' ? 'xlsx' : type}`;

  const path = `reports/${filename}`;



  const contentType = {

    pdf: 'application/pdf',

    excel: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',

    json: 'application/json',

  }[type];



  const { error: uploadError } = await supabaseAdmin.storage

    .from(STORAGE_BUCKET)

    .upload(path, buffer, { contentType, upsert: true });



  if (uploadError) throw uploadError;



  const { data: urlData } = supabaseAdmin.storage.from(STORAGE_BUCKET).getPublicUrl(path);



  const { data, error } = await supabaseAdmin

    .from('reports')

    .insert({

      project_id: projectId,

      file_url: urlData.publicUrl,

      report_type: type,

      summary,

    })

    .select()

    .single();



  if (error) throw error;

  return data;

}



export default { generatePdfReport, generateExcelReport, generateJsonReport, saveReport };


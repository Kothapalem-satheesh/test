/**
 * Compliance scoring engine
 * Calculates per-framework and overall compliance scores
 */

const STATUS_SCORES = {
  'Pass': 1,
  'Partial': 0.5,
  'Fail': 0,
  'Not Applicable': null, // excluded from scoring
};

const SEVERITY_RISK = {
  'Critical': 'High',
  'High': 'High',
  'Medium': 'Medium',
  'Low': 'Low',
};

/**
 * Calculate compliance scores from results array
 * @param {Array} results - compliance_results with joined requirements
 * @returns {Object} scoring summary
 */
export function calculateScores(results) {
  const frameworkMap = {};
  const riskSummary = { High: 0, Medium: 0, Low: 0 };
  const missingControls = [];

  for (const result of results) {
    const fwName = result.requirement?.framework?.name || result.framework_name || 'Unknown';
    if (!frameworkMap[fwName]) {
      frameworkMap[fwName] = { total: 0, scored: 0, pass: 0, partial: 0, fail: 0, na: 0 };
    }

    const fw = frameworkMap[fwName];
    fw.total++;

    const score = STATUS_SCORES[result.status];
    if (score === null) {
      fw.na++;
      continue;
    }

    fw.scored += score;
    fw.pass += result.status === 'Pass' ? 1 : 0;
    fw.partial += result.status === 'Partial' ? 1 : 0;
    fw.fail += result.status === 'Fail' ? 1 : 0;

    if (result.status === 'Fail' || result.status === 'Partial') {
      const severity = result.requirement?.severity || 'Medium';
      const riskLevel = SEVERITY_RISK[severity] || 'Medium';
      riskSummary[riskLevel]++;

      if (result.status === 'Fail') {
        missingControls.push({
          requirement_code: result.requirement?.requirement_code,
          requirement_text: result.requirement?.requirement_text,
          category: result.requirement?.category,
          severity,
          risk_level: riskLevel,
          recommendation: result.recommendation,
        });
      }
    }
  }

  const frameworkScores = {};
  let overallScored = 0;
  let overallApplicable = 0;

  for (const [name, fw] of Object.entries(frameworkMap)) {
    const applicable = fw.total - fw.na;
    const percentage = applicable > 0 ? Math.round((fw.scored / applicable) * 100) : 0;
    frameworkScores[name] = {
      percentage,
      total: fw.total,
      applicable,
      pass: fw.pass,
      partial: fw.partial,
      fail: fw.fail,
      notApplicable: fw.na,
    };
    overallScored += fw.scored;
    overallApplicable += applicable;
  }

  const overallPercentage = overallApplicable > 0
    ? Math.round((overallScored / overallApplicable) * 100)
    : 0;

  return {
    overallPercentage,
    frameworkScores,
    riskSummary,
    missingControls: missingControls.sort((a, b) => {
      const order = { Critical: 0, High: 1, Medium: 2, Low: 3 };
      return (order[a.severity] || 2) - (order[b.severity] || 2);
    }),
    totalResults: results.length,
  };
}

/**
 * Determine risk level for a single result
 */
export function getRiskLevel(status, severity) {
  if (status === 'Pass' || status === 'Not Applicable') return null;
  return SEVERITY_RISK[severity] || 'Medium';
}

export default { calculateScores, getRiskLevel };

import Anthropic from '@anthropic-ai/sdk';
import axios from 'axios';
import { config } from '../config/index.js';

const anthropic = config.anthropicApiKey
  ? new Anthropic({ apiKey: config.anthropicApiKey })
  : null;

const COMPLIANCE_SYSTEM_PROMPT = `You are a senior GRC (Governance, Risk, Compliance) auditor with expertise in:
- NIST Cybersecurity Framework (CSF) 2.0
- OWASP ASVS, SAMM, and Top 10
- CIS Critical Security Controls v8
- ISO/IEC 27001:2022 Annex A
- PCI DSS 4.0, SOC 2 Trust Services Criteria
- GDPR (EU General Data Protection Regulation)
- HIPAA Security Rule (45 CFR Part 164)

ASSESSMENT METHODOLOGY:
1. Read each document excerpt carefully — note the source file, page, and section.
2. Match excerpts to the specific requirement using both semantic meaning and keywords.
3. Pass = clear, documented evidence that the control is implemented.
4. Partial = related policy exists but gaps remain (missing scope, frequency, roles, or enforcement).
5. Fail = no relevant evidence OR evidence contradicts the requirement.
6. Not Applicable = requirement clearly outside organizational scope (explain why).

EVIDENCE RULES:
- Quote exact text from excerpts when possible (use quotation marks).
- Never invent policies, tools, or procedures not present in the excerpts.
- If excerpts are weak or off-topic, score Fail with low confidence and explain what evidence is missing.
- Similarity scores indicate retrieval relevance — low similarity excerpts should be weighted cautiously.

Respond with ONLY valid JSON (no markdown fences):
{
  "status": "Pass" | "Partial" | "Fail" | "Not Applicable",
  "confidence": <integer 0-100>,
  "evidence": [{"text": "...", "source_document": "...", "page_or_section": "..."}],
  "reasoning": "<structured: what was found, what is missing, conclusion>",
  "recommendation": "<specific remediation if Partial/Fail; confirmation if Pass>"
}`;

function buildUserPrompt(requirement, chunks, documentMap) {
  const chunksContext = chunks.length
    ? chunks.map((chunk, i) => {
        const docName = documentMap[chunk.document_id] || 'Unknown Document';
        const sim = chunk.similarity != null ? `${(chunk.similarity * 100).toFixed(0)}%` : 'N/A';
        const kw = chunk.keyword_score != null ? `${(chunk.keyword_score * 100).toFixed(0)}%` : 'N/A';
        return `[Excerpt ${i + 1}] Relevance: ${sim} | Keyword match: ${kw}
Source: ${docName} | Page: ${chunk.page_number || 'N/A'} | Section: ${chunk.section_title || 'N/A'}
Content:
${chunk.content}`;
      }).join('\n\n---\n\n')
    : 'No relevant document excerpts were retrieved. Assess as Fail unless clearly Not Applicable.';

  return `## Requirement
Framework: ${requirement.framework_name || 'N/A'}
Code: ${requirement.requirement_code}
Category: ${requirement.category || 'General'}
Severity: ${requirement.severity || 'Medium'}

Requirement:
${requirement.requirement_text}

Expected evidence types:
${requirement.expected_evidence || 'Policy, procedure, or technical control documentation'}

Search keywords: ${(requirement.keywords || []).join(', ') || 'none'}

## Document excerpts (${chunks.length})
${chunksContext}

Assess this requirement strictly against the excerpts above. Return ONLY valid JSON.`;
}

function getActiveProvider() {
  if (config.llmProvider === 'anthropic' && config.anthropicApiKey) return 'anthropic';
  if (config.groqApiKey) return 'groq';
  if (config.anthropicApiKey) return 'anthropic';
  return null;
}

async function callGroq(userPrompt) {
  const { data } = await axios.post(
    `${config.groqBaseUrl}/chat/completions`,
    {
      model: config.groqModel,
      messages: [
        { role: 'system', content: COMPLIANCE_SYSTEM_PROMPT },
        { role: 'user', content: userPrompt },
      ],
      temperature: 0.2,
      max_tokens: 2048,
      response_format: { type: 'json_object' },
    },
    {
      headers: {
        Authorization: `Bearer ${config.groqApiKey}`,
        'Content-Type': 'application/json',
      },
      timeout: 60000,
    }
  );

  return data.choices?.[0]?.message?.content || '';
}

async function callAnthropic(userPrompt) {
  const response = await anthropic.messages.create({
    model: config.anthropicModel,
    max_tokens: 2048,
    system: COMPLIANCE_SYSTEM_PROMPT,
    messages: [{ role: 'user', content: userPrompt }],
  });
  return response.content[0]?.text || '';
}

async function callLLM(userPrompt) {
  const provider = getActiveProvider();
  if (!provider) {
    throw new Error('No LLM configured. Set GROQ_API_KEY or ANTHROPIC_API_KEY in .env');
  }
  if (provider === 'groq') return callGroq(userPrompt);
  return callAnthropic(userPrompt);
}

/**
 * Assess compliance for a single requirement against retrieved document chunks
 */
export async function assessCompliance(requirement, chunks, documentMap) {
  const userPrompt = buildUserPrompt(requirement, chunks, documentMap);

  const text = await callLLM(userPrompt);
  return parseComplianceResponse(text, async () => callLLM(userPrompt));
}

/**
 * Defensively parse LLM JSON response with retry logic
 */
export async function parseComplianceResponse(text, retryFn = null) {
  let cleaned = text.trim();

  cleaned = cleaned.replace(/^```(?:json)?\s*/i, '').replace(/\s*```$/i, '');

  try {
    const parsed = JSON.parse(cleaned);
    validateComplianceResult(parsed);
    return parsed;
  } catch (firstError) {
    const jsonMatch = cleaned.match(/\{[\s\S]*\}/);
    if (jsonMatch) {
      try {
        const parsed = JSON.parse(jsonMatch[0]);
        validateComplianceResult(parsed);
        return parsed;
      } catch {
        // fall through to retry
      }
    }

    if (retryFn) {
      console.warn('LLM response parse failed, retrying...', firstError.message);
      const retryText = await retryFn();
      return parseComplianceResponse(retryText);
    }

    return {
      status: 'Fail',
      confidence: 0,
      evidence: [],
      reasoning: 'Unable to parse LLM assessment response. Manual review required.',
      recommendation: 'Re-run analysis or review manually.',
    };
  }
}

function validateComplianceResult(result) {
  const validStatuses = ['Pass', 'Partial', 'Fail', 'Not Applicable'];
  if (!validStatuses.includes(result.status)) {
    throw new Error(`Invalid status: ${result.status}`);
  }
  if (typeof result.confidence !== 'number') {
    result.confidence = 50;
  }
  if (!Array.isArray(result.evidence)) {
    result.evidence = [];
  }
  if (!result.reasoning) result.reasoning = '';
  if (!result.recommendation) result.recommendation = '';
}

export function getLlmProviderInfo() {
  const provider = getActiveProvider();
  return {
    provider: provider || 'none',
    model: provider === 'groq' ? config.groqModel : config.anthropicModel,
  };
}

export default { assessCompliance, parseComplianceResponse, getLlmProviderInfo };

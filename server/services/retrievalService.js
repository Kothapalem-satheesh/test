/**
 * Hybrid retrieval: vector similarity + keyword boosting + similarity floor.
 */

function keywordScore(text, keywords) {
  if (!keywords?.length || !text) return 0;
  const lower = text.toLowerCase();
  let hits = 0;
  for (const kw of keywords) {
    if (kw && lower.includes(kw.toLowerCase())) hits += 1;
  }
  return hits / keywords.length;
}

/**
 * Re-rank vector search results using keyword overlap and similarity threshold.
 */
export function rankAndFilterChunks(chunks, requirement, options = {}) {
  const {
    similarityThreshold = 0.32,
    vectorWeight = 0.65,
    keywordWeight = 0.35,
    topK = 5,
  } = options;

  const keywords = requirement.keywords || [];
  const requirementTerms = [
    requirement.requirement_code,
    requirement.category,
    ...(requirement.requirement_text || '').split(/\s+/).slice(0, 12),
  ].filter(Boolean);

  const allKeywords = [...new Set([...keywords, ...requirementTerms])];

  const scored = (chunks || []).map((chunk) => {
    const similarity = Number(chunk.similarity) || 0;
    const kw = keywordScore(chunk.content, allKeywords);
    const hybrid = similarity * vectorWeight + kw * keywordWeight;
    return { ...chunk, similarity, keyword_score: kw, hybrid_score: hybrid };
  });

  const filtered = scored
    .filter((c) => c.similarity >= similarityThreshold || c.keyword_score >= 0.25)
    .sort((a, b) => b.hybrid_score - a.hybrid_score)
    .slice(0, topK);

  return filtered;
}

/**
 * Keyword fallback when vector search returns nothing useful.
 */
export async function keywordFallbackChunks(db, projectId, requirement, limit = 5) {
  const keywords = (requirement.keywords || []).slice(0, 5);
  if (!keywords.length) return [];

  const { data: docs } = await db
    .from('documents')
    .select('id')
    .eq('project_id', projectId)
    .eq('status', 'ready');

  if (!docs?.length) return [];

  const docIds = docs.map((d) => d.id);
  const results = [];

  for (const kw of keywords) {
    const { data } = await db
      .from('document_chunks')
      .select('id, document_id, content, page_number, section_title')
      .in('document_id', docIds)
      .ilike('content', `%${kw}%`)
      .limit(limit);

    for (const row of data || []) {
      if (!results.find((r) => r.id === row.id)) {
        results.push({
          ...row,
          similarity: 0.4,
          keyword_score: 1,
          hybrid_score: 0.5,
        });
      }
    }
    if (results.length >= limit) break;
  }

  return results.slice(0, limit);
}

export default { rankAndFilterChunks, keywordFallbackChunks };

import { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { analysisApi } from '../services/api';

const STATUS_BADGE = {
  Pass: 'badge-pass',
  Partial: 'badge-partial',
  Fail: 'badge-fail',
  'Not Applicable': 'badge-na',
};

export default function ResultsDetail() {
  const { resultId } = useParams();
  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    analysisApi.result(resultId)
      .then(({ data }) => setResult(data))
      .catch(() => {})
      .finally(() => setLoading(false));
  }, [resultId]);

  if (loading) {
    return (
      <div className="flex items-center justify-center py-24">
        <div className="animate-spin rounded-full h-7 w-7 border-2 border-slate-200 border-t-primary-600" />
      </div>
    );
  }

  if (!result) {
    return <p className="text-center py-24 text-slate-500">Result not found</p>;
  }

  const req = result.requirement || {};

  return (
    <div className="max-w-3xl mx-auto px-4 sm:px-6 py-8">
      <Link to={`/projects/${result.project_id}`} className="text-xs font-semibold text-primary-600 hover:text-primary-700">
        &larr; Back
      </Link>

      <div className="mt-4 mb-6">
        <div className="flex flex-wrap items-center gap-2 mb-3">
          <span className="font-mono text-xs font-bold bg-slate-100 text-slate-700 px-2 py-1 rounded">{req.requirement_code}</span>
          <span className={STATUS_BADGE[result.status]}>{result.status}</span>
          <span className="text-xs text-slate-500">{result.confidence}% confidence</span>
          {result.risk_level && (
            <span className={`text-xs font-semibold px-2 py-0.5 rounded-md ${
              result.risk_level === 'High' ? 'bg-red-50 text-red-700' :
              result.risk_level === 'Medium' ? 'bg-amber-50 text-amber-800' :
              'bg-blue-50 text-blue-700'
            }`}>{result.risk_level} risk</span>
          )}
        </div>
        <h1 className="text-xl font-bold leading-snug">{req.requirement_text}</h1>
        <p className="text-xs text-slate-500 mt-2">
          {req.framework?.name} · {req.category} · {req.severity}
        </p>
      </div>

      <div className="space-y-4">
        <section className="card">
          <h2 className="text-sm font-semibold text-slate-800 mb-2">Reasoning</h2>
          <p className="text-sm text-slate-600 leading-relaxed whitespace-pre-wrap">{result.reasoning || '—'}</p>
        </section>

        <section className="card">
          <h2 className="text-sm font-semibold text-slate-800 mb-3">
            Evidence {result.evidence?.length > 0 && `(${result.evidence.length})`}
          </h2>
          {result.evidence?.length > 0 ? (
            <div className="space-y-3">
              {result.evidence.map((ev, i) => (
                <div key={i} className="border-l-2 border-primary-400 pl-3">
                  <p className="text-xs font-medium text-slate-500 mb-1">
                    {ev.source_document || 'Document'}
                    {ev.page_or_section && ` · ${ev.page_or_section}`}
                  </p>
                  <blockquote className="text-sm text-slate-700 bg-slate-50 p-3 rounded-lg">
                    &ldquo;{ev.text}&rdquo;
                  </blockquote>
                </div>
              ))}
            </div>
          ) : (
            <p className="text-sm text-slate-500">No matching text in uploaded documents.</p>
          )}
        </section>

        <section className="card">
          <h2 className="text-sm font-semibold text-slate-800 mb-2">Recommendation</h2>
          <p className="text-sm text-slate-600 leading-relaxed">
            {result.recommendation || req.recommendation_text || '—'}
          </p>
        </section>
      </div>
    </div>
  );
}

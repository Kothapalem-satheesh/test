const STATUS = {
  processing: { label: 'Processing', className: 'bg-blue-50 text-blue-700' },
  ready: { label: 'Ready', className: 'bg-emerald-50 text-emerald-700' },
  failed: { label: 'Failed', className: 'bg-red-50 text-red-700' },
};

function fileIcon(type) {
  return (type || 'file').slice(0, 3).toUpperCase();
}

export default function DocumentList({ documents, deletingId, reprocessingId, onDelete, onReprocess }) {
  if (documents.length === 0) return null;

  return (
    <div className="card">
      <h3 className="text-base font-semibold mb-4">Files ({documents.length})</h3>
      <ul className="divide-y divide-slate-100">
        {documents.map((doc) => {
          const status = STATUS[doc.status] || STATUS.processing;
          const isDeleting = deletingId === doc.id;
          const isReprocessing = reprocessingId === doc.id;
          const canReprocess = doc.status === 'ready' || doc.status === 'failed';

          return (
            <li key={doc.id} className="flex items-center gap-3 py-3 first:pt-0 last:pb-0">
              <div className="w-9 h-9 bg-slate-100 rounded-lg flex items-center justify-center shrink-0">
                <span className="text-[10px] font-bold text-slate-600">{fileIcon(doc.file_type)}</span>
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-sm font-medium text-slate-900 truncate">{doc.filename}</p>
                <p className="text-xs text-slate-500">
                  {(doc.file_size / 1024).toFixed(1)} KB
                </p>
              </div>
              <span className={`text-xs font-semibold px-2 py-0.5 rounded-md shrink-0 ${status.className}`}>
                {status.label}
              </span>
              {canReprocess && onReprocess && (
                <button
                  type="button"
                  onClick={() => onReprocess(doc)}
                  disabled={isReprocessing || isDeleting}
                  className="btn-ghost shrink-0"
                  title="Re-extract text with improved NLP"
                  aria-label={`Reprocess ${doc.filename}`}
                >
                  {isReprocessing ? (
                    <span className="w-4 h-4 border-2 border-slate-300 border-t-slate-600 rounded-full animate-spin inline-block" />
                  ) : (
                    <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                      <path strokeLinecap="round" strokeLinejoin="round" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                    </svg>
                  )}
                </button>
              )}
              <button
                type="button"
                onClick={() => onDelete(doc)}
                disabled={isDeleting}
                className="btn-ghost shrink-0"
                title="Remove file"
                aria-label={`Delete ${doc.filename}`}
              >
                {isDeleting ? (
                  <span className="w-4 h-4 border-2 border-slate-300 border-t-slate-600 rounded-full animate-spin inline-block" />
                ) : (
                  <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                    <path strokeLinecap="round" strokeLinejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                  </svg>
                )}
              </button>
            </li>
          );
        })}
      </ul>
    </div>
  );
}

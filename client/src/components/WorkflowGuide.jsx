const STEPS = [
  { id: 'frameworks', label: 'Frameworks', tab: 'frameworks' },
  { id: 'upload', label: 'Documents', tab: 'documents' },
  { id: 'analyze', label: 'Analyze', tab: 'overview' },
  { id: 'results', label: 'Results', tab: 'results' },
];

function stepStatus(stepId, state) {
  const { selectedFrameworks, readyDocs, totalDocs, hasScores, analyzing } = state;

  switch (stepId) {
    case 'frameworks':
      return selectedFrameworks.length > 0 ? 'done' : 'current';
    case 'upload':
      if (readyDocs > 0 && readyDocs === totalDocs && totalDocs > 0) return 'done';
      if (selectedFrameworks.length > 0) return totalDocs > 0 ? 'current' : 'current';
      return 'pending';
    case 'analyze':
      if (hasScores) return 'done';
      if (analyzing) return 'current';
      if (readyDocs > 0 && selectedFrameworks.length > 0) return 'current';
      return 'pending';
    case 'results':
      return hasScores ? 'current' : 'pending';
    default:
      return 'pending';
  }
}

const circleStyles = {
  done: 'bg-emerald-500 text-white border-emerald-500',
  current: 'bg-primary-600 text-white border-primary-600 ring-4 ring-primary-100',
  pending: 'bg-white text-slate-400 border-slate-200',
};

export default function WorkflowGuide({ state, onGoToTab }) {
  return (
    <nav aria-label="Assessment steps" className="card !p-4 sm:!p-5">
      <ol className="flex items-center gap-2 sm:gap-0">
        {STEPS.map((step, index) => {
          const status = stepStatus(step.id, state);
          const isClickable = status !== 'pending';

          return (
            <li key={step.id} className="flex items-center flex-1 min-w-0">
              <button
                type="button"
                disabled={!isClickable}
                onClick={() => isClickable && onGoToTab?.(step.tab)}
                className={`flex flex-col sm:flex-row items-center gap-1.5 sm:gap-2 w-full group ${
                  isClickable ? 'cursor-pointer' : 'cursor-default'
                }`}
              >
                <span
                  className={`shrink-0 w-8 h-8 rounded-full border-2 flex items-center justify-center text-xs font-bold transition-colors ${circleStyles[status]}`}
                >
                  {status === 'done' ? (
                    <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={3}>
                      <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
                    </svg>
                  ) : (
                    index + 1
                  )}
                </span>
                <span
                  className={`text-xs sm:text-sm font-semibold truncate ${
                    status === 'current' ? 'text-primary-700' : status === 'done' ? 'text-slate-700' : 'text-slate-400'
                  } ${isClickable ? 'group-hover:text-primary-600' : ''}`}
                >
                  {step.label}
                </span>
              </button>
              {index < STEPS.length - 1 && (
                <div
                  className={`hidden sm:block h-0.5 flex-1 mx-2 rounded ${
                    stepStatus(STEPS[index + 1].id, state) !== 'pending' ? 'bg-emerald-300' : 'bg-slate-200'
                  }`}
                />
              )}
            </li>
          );
        })}
      </ol>
    </nav>
  );
}

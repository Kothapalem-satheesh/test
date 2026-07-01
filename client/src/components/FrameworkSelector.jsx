const CORE_FRAMEWORKS = [
  'NIST CSF',
  'OWASP ASVS',
  'OWASP SAMM',
  'OWASP Top 10',
  'CIS Controls',
  'ISO/IEC 27001',
];

function FrameworkOption({ fw, selected, onToggle }) {
  return (
    <label
      className={`flex items-center gap-3 p-3 border rounded-lg cursor-pointer transition-colors ${
        selected.includes(fw.name)
          ? 'border-primary-300 bg-primary-50/60'
          : 'border-slate-200 hover:border-slate-300 hover:bg-slate-50/50'
      }`}
    >
      <input
        type="checkbox"
        checked={selected.includes(fw.name)}
        onChange={() => onToggle(fw.name)}
        className="rounded border-slate-300 text-primary-600 focus:ring-primary-500"
      />
      <span className="text-sm font-medium text-slate-800">{fw.name}</span>
      {fw.optional && (
        <span className="text-[10px] uppercase tracking-wide bg-violet-50 text-violet-700 px-1.5 py-0.5 rounded font-semibold ml-auto">
          Optional
        </span>
      )}
    </label>
  );
}

export default function FrameworkSelector({
  frameworks,
  selected,
  onChange,
  showSelectAll = true,
}) {
  const toggleFramework = (fwName) => {
    onChange(
      selected.includes(fwName)
        ? selected.filter((f) => f !== fwName)
        : [...selected, fwName]
    );
  };

  const selectAllCore = () => {
    const core = frameworks.filter((f) => CORE_FRAMEWORKS.includes(f.name)).map((f) => f.name);
    onChange(core);
  };

  const coreFrameworks = frameworks.filter((f) => !f.optional);
  const optionalFrameworks = frameworks.filter((f) => f.optional);

  if (frameworks.length === 0) {
    return (
      <div className="rounded-lg border border-amber-200 bg-amber-50 p-4 text-sm text-amber-900">
        <p className="font-semibold mb-1">No frameworks in database</p>
        <p className="text-amber-800">
          Run <code className="bg-white/80 px-1 rounded text-xs">004_seed_frameworks_data.sql</code> in
          Supabase SQL Editor, then refresh.
        </p>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      {showSelectAll && (
        <div className="flex justify-end">
          <button type="button" onClick={selectAllCore} className="text-xs font-semibold text-primary-600 hover:text-primary-700">
            Select all core
          </button>
        </div>
      )}
      {coreFrameworks.length > 0 && (
        <div className="grid sm:grid-cols-2 gap-2">
          {coreFrameworks.map((fw) => (
            <FrameworkOption key={fw.id} fw={fw} selected={selected} onToggle={toggleFramework} />
          ))}
        </div>
      )}
      {optionalFrameworks.length > 0 && (
        <div>
          <p className="text-xs font-semibold text-slate-400 uppercase tracking-wider mb-2">Optional</p>
          <div className="grid sm:grid-cols-2 gap-2">
            {optionalFrameworks.map((fw) => (
              <FrameworkOption key={fw.id} fw={fw} selected={selected} onToggle={toggleFramework} />
            ))}
          </div>
        </div>
      )}
    </div>
  );
}

import { useCallback, useState } from 'react';

export default function FileUpload({ onUpload, uploading }) {
  const [dragOver, setDragOver] = useState(false);

  const handleFiles = useCallback((files) => {
    const allowed = ['pdf', 'docx', 'txt', 'md', 'xlsx'];
    const valid = Array.from(files).filter((f) => {
      const ext = f.name.split('.').pop()?.toLowerCase();
      return allowed.includes(ext);
    });
    if (valid.length > 0) onUpload(valid);
  }, [onUpload]);

  const onDrop = (e) => {
    e.preventDefault();
    setDragOver(false);
    handleFiles(e.dataTransfer.files);
  };

  return (
    <div
      className={`border-2 border-dashed rounded-xl p-8 text-center transition-colors ${
        dragOver ? 'border-primary-400 bg-primary-50/50' : 'border-slate-200 hover:border-slate-300'
      } ${uploading ? 'opacity-60 pointer-events-none' : ''}`}
      onDragOver={(e) => { e.preventDefault(); setDragOver(true); }}
      onDragLeave={() => setDragOver(false)}
      onDrop={onDrop}
    >
      <div className="w-12 h-12 bg-slate-100 rounded-full flex items-center justify-center mx-auto mb-3">
        <svg className="w-6 h-6 text-slate-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5}
            d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" />
        </svg>
      </div>
      <p className="text-sm font-semibold text-slate-800">
        {uploading ? 'Uploading…' : 'Drop files here or browse'}
      </p>
      <p className="text-xs text-slate-500 mt-1">PDF, DOCX, TXT, MD, XLSX · 25 MB max</p>
      <label className="btn-secondary inline-block mt-4 cursor-pointer">
        Browse
        <input
          type="file"
          multiple
          className="hidden"
          accept=".pdf,.docx,.txt,.md,.xlsx"
          onChange={(e) => handleFiles(e.target.files)}
          disabled={uploading}
        />
      </label>
    </div>
  );
}

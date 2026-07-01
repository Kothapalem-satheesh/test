import { useState, useEffect, useCallback } from 'react';
import { useParams, Link } from 'react-router-dom';
import {
  projectsApi, documentsApi, analysisApi, reportsApi, frameworksApi,
} from '../services/api';
import FileUpload from '../components/FileUpload';
import DocumentList from '../components/DocumentList';
import { ScoreGauge, FrameworkBarChart, RiskPieChart, StatusDistribution } from '../components/Charts';
import ResultsTable from '../components/ResultsTable';
import WorkflowGuide from '../components/WorkflowGuide';
import FrameworkSelector from '../components/FrameworkSelector';

const TABS = [
  { id: 'frameworks', label: 'Frameworks' },
  { id: 'documents', label: 'Documents' },
  { id: 'overview', label: 'Analysis' },
  { id: 'results', label: 'Results' },
];

export default function ProjectDetail() {
  const { id } = useParams();
  const [project, setProject] = useState(null);
  const [documents, setDocuments] = useState([]);
  const [frameworks, setFrameworks] = useState([]);
  const [selectedFrameworks, setSelectedFrameworks] = useState([]);
  const [savingFrameworks, setSavingFrameworks] = useState(false);
  const [frameworksDirty, setFrameworksDirty] = useState(false);
  const [deletingDocId, setDeletingDocId] = useState(null);
  const [reprocessingDocId, setReprocessingDocId] = useState(null);
  const [scores, setScores] = useState(null);
  const [results, setResults] = useState([]);
  const [filteredResults, setFilteredResults] = useState([]);
  const [filters, setFilters] = useState({});
  const [loading, setLoading] = useState(true);
  const [uploading, setUploading] = useState(false);
  const [analyzing, setAnalyzing] = useState(false);
  const [activeTab, setActiveTab] = useState('frameworks');
  const [error, setError] = useState('');
  const [reportLoading, setReportLoading] = useState('');

  const loadProject = useCallback(async () => {
    try {
      const [projRes, docsRes] = await Promise.all([
        projectsApi.get(id),
        documentsApi.list(id),
      ]);
      setProject(projRes.data);
      setSelectedFrameworks(projRes.data.selected_frameworks || []);
      setFrameworksDirty(false);
      setDocuments(docsRes.data);
      setAnalyzing(projRes.data.analysis_status === 'running');
    } catch {
      setError('Failed to load project');
    } finally {
      setLoading(false);
    }
  }, [id]);

  const loadScores = useCallback(async () => {
    try {
      const { data } = await projectsApi.scores(id);
      setScores(data);
    } catch { /* no scores yet */ }
  }, [id]);

  const applyFilters = useCallback((data, f) => {
    let filtered = [...data];
    if (f.status) filtered = filtered.filter((r) => r.status === f.status);
    if (f.framework) filtered = filtered.filter((r) => r.requirement?.framework?.name === f.framework);
    if (f.severity) filtered = filtered.filter((r) => r.requirement?.severity === f.severity);
    if (f.sort === 'status') filtered.sort((a, b) => a.status.localeCompare(b.status));
    else if (f.sort === 'severity') {
      const order = { Critical: 0, High: 1, Medium: 2, Low: 3 };
      filtered.sort((a, b) => (order[a.requirement?.severity] || 2) - (order[b.requirement?.severity] || 2));
    }
    setFilteredResults(filtered);
  }, []);

  const loadResults = useCallback(async () => {
    try {
      const { data } = await analysisApi.results(id, filters);
      setResults(data);
      applyFilters(data, filters);
    } catch { /* no results yet */ }
  }, [id, filters, applyFilters]);

  useEffect(() => { loadProject(); }, [loadProject]);
  useEffect(() => { loadScores(); loadResults(); }, [loadScores, loadResults]);
  useEffect(() => {
    frameworksApi.list().then(({ data }) => setFrameworks(data || [])).catch(() => {});
  }, []);

  useEffect(() => {
    if (!analyzing) return;
    const interval = setInterval(async () => {
      try {
        const { data } = await analysisApi.status(id);
        setProject((p) => ({ ...p, analysis_status: data.status, analysis_progress: data.progress }));
        if (data.status === 'completed' || data.status === 'failed') {
          setAnalyzing(false);
          if (data.status === 'failed') {
            setError(data.progress?.message || 'Analysis failed');
          }
          loadScores();
          loadResults();
        }
      } catch { /* ignore */ }
    }, 3000);
    return () => clearInterval(interval);
  }, [analyzing, id, loadScores, loadResults]);

  useEffect(() => {
    const processing = documents.some((d) => d.status === 'processing');
    if (!processing) return;
    const interval = setInterval(() => documentsApi.list(id).then(({ data }) => setDocuments(data)), 5000);
    return () => clearInterval(interval);
  }, [documents, id]);

  const handleFilterChange = (newFilters) => {
    setFilters(newFilters);
    applyFilters(results, newFilters);
  };

  const handleUpload = async (files) => {
    setUploading(true);
    setError('');
    try {
      await documentsApi.upload(id, files);
      const { data } = await documentsApi.list(id);
      setDocuments(data);
    } catch (err) {
      setError(err.response?.data?.error || 'Upload failed');
    } finally {
      setUploading(false);
    }
  };

  const handleDeleteDocument = async (doc) => {
    if (!window.confirm(`Remove "${doc.filename}"?`)) return;
    setDeletingDocId(doc.id);
    setError('');
    try {
      await documentsApi.delete(doc.id);
      setDocuments((prev) => prev.filter((d) => d.id !== doc.id));
    } catch (err) {
      setError(err.response?.data?.error || 'Could not delete file');
    } finally {
      setDeletingDocId(null);
    }
  };

  const handleReprocessDocument = async (doc) => {
    setReprocessingDocId(doc.id);
    setError('');
    try {
      await documentsApi.reprocess(doc.id);
      setDocuments((prev) =>
        prev.map((d) => (d.id === doc.id ? { ...d, status: 'processing', error_message: null } : d)),
      );
    } catch (err) {
      setError(err.response?.data?.error || 'Could not reprocess file');
    } finally {
      setReprocessingDocId(null);
    }
  };

  const handleFrameworkChange = (next) => {
    setSelectedFrameworks(next);
    setFrameworksDirty(true);
  };

  const handleSaveFrameworks = async () => {
    setSavingFrameworks(true);
    setError('');
    try {
      const { data } = await projectsApi.update(id, { selected_frameworks: selectedFrameworks });
      setProject(data);
      setFrameworksDirty(false);
    } catch (err) {
      setError(err.response?.data?.error || 'Failed to save');
    } finally {
      setSavingFrameworks(false);
    }
  };

  const handleStartAnalysis = async () => {
    if (frameworksDirty) await handleSaveFrameworks();
    setAnalyzing(true);
    setError('');
    try {
      await analysisApi.start(id, []);
    } catch (err) {
      setError(err.response?.data?.error || 'Failed to start analysis');
      setAnalyzing(false);
    }
  };

  const handleDownloadReport = async (type) => {
    setReportLoading(type);
    setError('');
    try {
      const { data } = await reportsApi.download(id, type);
      const ext = type === 'excel' ? 'xlsx' : type;
      const mime = {
        pdf: 'application/pdf',
        excel: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        json: 'application/json',
      }[type] || 'application/octet-stream';
      const url = window.URL.createObjectURL(new Blob([data], { type: mime }));
      const a = document.createElement('a');
      a.href = url;
      a.download = `compliance-report-${project.name.replace(/\s+/g, '-')}.${ext}`;
      a.click();
      window.URL.revokeObjectURL(url);
    } catch (err) {
      let message = 'Export failed';
      const payload = err.response?.data;
      if (payload instanceof Blob) {
        try {
          const parsed = JSON.parse(await payload.text());
          message = parsed.error || message;
        } catch { /* default */ }
      } else if (payload?.error) {
        message = payload.error;
      }
      setError(message);
    } finally {
      setReportLoading('');
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-24">
        <div className="animate-spin rounded-full h-7 w-7 border-2 border-slate-200 border-t-primary-600" />
      </div>
    );
  }

  if (!project) {
    return <p className="text-center py-24 text-slate-500">Project not found</p>;
  }

  const readyDocs = documents.filter((d) => d.status === 'ready');
  const progress = project.analysis_progress || {};
  const canAnalyze = readyDocs.length > 0 && selectedFrameworks.length > 0 && !analyzing;
  const workflowState = {
    selectedFrameworks,
    readyDocs: readyDocs.length,
    totalDocs: documents.length,
    hasScores: !!scores,
    analyzing,
  };

  const tabBadge = (tabId) => {
    if (tabId === 'frameworks' && selectedFrameworks.length > 0) return selectedFrameworks.length;
    if (tabId === 'documents' && documents.length > 0) return documents.length;
    if (tabId === 'results' && results.length > 0) return results.length;
    return null;
  };

  return (
    <div className="max-w-6xl mx-auto px-4 sm:px-6 py-6 sm:py-8">
      <div className="mb-5">
        <Link to="/" className="text-xs font-semibold text-primary-600 hover:text-primary-700">&larr; Projects</Link>
        <h1 className="text-2xl sm:text-3xl font-bold mt-1">{project.name}</h1>
        {project.description && <p className="text-sm text-slate-500 mt-0.5">{project.description}</p>}
      </div>

      {error && (
        <div className="bg-red-50 text-red-700 text-sm p-3 rounded-lg mb-4 flex justify-between gap-3 border border-red-100">
          <span>{error}</span>
          <button type="button" onClick={() => setError('')} className="text-red-400 hover:text-red-600 shrink-0 font-bold">×</button>
        </div>
      )}

      <div className="mb-5">
        <WorkflowGuide state={workflowState} onGoToTab={setActiveTab} />
      </div>

      {analyzing && (
        <div className="card mb-5 !py-4">
          <div className="flex justify-between text-sm font-medium mb-2">
            <span>Analyzing…</span>
            <span className="text-slate-500">{progress.current}/{progress.total}</span>
          </div>
          <div className="w-full bg-slate-100 rounded-full h-1.5">
            <div
              className="bg-primary-600 h-1.5 rounded-full transition-all duration-500"
              style={{ width: progress.total ? `${(progress.current / progress.total) * 100}%` : '0%' }}
            />
          </div>
          {progress.message && <p className="text-xs text-slate-500 mt-2">{progress.message}</p>}
        </div>
      )}

      <div className="flex gap-1 mb-5 border-b border-slate-200 overflow-x-auto">
        {TABS.map((tab) => {
          const badge = tabBadge(tab.id);
          return (
            <button
              key={tab.id}
              type="button"
              onClick={() => setActiveTab(tab.id)}
              className={`tab-btn whitespace-nowrap ${activeTab === tab.id ? 'tab-btn-active' : 'tab-btn-inactive'}`}
            >
              {tab.label}
              {badge != null && (
                <span className="ml-1.5 text-[10px] bg-slate-100 text-slate-600 px-1.5 py-0.5 rounded-full font-bold">{badge}</span>
              )}
            </button>
          );
        })}
      </div>

      {activeTab === 'frameworks' && (
        <div className="card">
          <div className="flex items-center justify-between gap-4 mb-4">
            <h2 className="text-base font-semibold">Select frameworks</h2>
            <button
              type="button"
              onClick={handleSaveFrameworks}
              className="btn-primary !py-2 !px-3 text-xs"
              disabled={savingFrameworks || !frameworksDirty}
            >
              {savingFrameworks ? 'Saving…' : 'Save'}
            </button>
          </div>
          <FrameworkSelector
            frameworks={frameworks}
            selected={selectedFrameworks}
            onChange={handleFrameworkChange}
          />
        </div>
      )}

      {activeTab === 'documents' && (
        <div className="space-y-4">
          <FileUpload onUpload={handleUpload} uploading={uploading} />
          <DocumentList
            documents={documents}
            deletingId={deletingDocId}
            reprocessingId={reprocessingDocId}
            onDelete={handleDeleteDocument}
            onReprocess={handleReprocessDocument}
          />
        </div>
      )}

      {activeTab === 'overview' && (
        <div className="space-y-5">
          <div className="flex flex-wrap gap-2 items-center">
            <button onClick={handleStartAnalysis} className="btn-primary" disabled={!canAnalyze}>
              {analyzing ? 'Analyzing…' : 'Run analysis'}
            </button>
            {scores && (
              <>
                <button onClick={() => handleDownloadReport('pdf')} className="btn-secondary" disabled={!!reportLoading}>
                  {reportLoading === 'pdf' ? 'Exporting…' : 'PDF'}
                </button>
                <button onClick={() => handleDownloadReport('excel')} className="btn-secondary" disabled={!!reportLoading}>
                  Excel
                </button>
                <button onClick={() => handleDownloadReport('json')} className="btn-secondary" disabled={!!reportLoading}>
                  JSON
                </button>
              </>
            )}
          </div>

          {!canAnalyze && !analyzing && (
            <p className="text-xs text-slate-500">
              {selectedFrameworks.length === 0 && 'Select frameworks. '}
              {readyDocs.length === 0 && 'Upload files and wait until status is Ready.'}
            </p>
          )}

          {scores ? (
            <>
              <div className="grid gap-4 lg:grid-cols-3">
                <div className="card">
                  <h3 className="text-xs font-semibold text-slate-500 uppercase tracking-wide mb-2">Overall</h3>
                  <ScoreGauge percentage={scores.overallPercentage} />
                </div>
                <div className="card">
                  <h3 className="text-xs font-semibold text-slate-500 uppercase tracking-wide mb-2">By framework</h3>
                  <FrameworkBarChart frameworkScores={scores.frameworkScores} />
                </div>
                <div className="card">
                  <h3 className="text-xs font-semibold text-slate-500 uppercase tracking-wide mb-2">Risk</h3>
                  <RiskPieChart riskSummary={scores.riskSummary} />
                </div>
              </div>

              {scores.missingControls?.length > 0 && (
                <div className="card">
                  <div className="flex justify-between items-center mb-3">
                    <h3 className="text-base font-semibold">Failures ({scores.missingControls.length})</h3>
                    <button type="button" onClick={() => setActiveTab('results')} className="text-xs font-semibold text-primary-600">
                      View all →
                    </button>
                  </div>
                  <div className="space-y-2 max-h-56 overflow-y-auto">
                    {scores.missingControls.slice(0, 8).map((ctrl, i) => (
                      <div key={i} className="flex gap-2 p-2.5 bg-red-50/80 rounded-lg text-sm">
                        <span className="text-[10px] font-mono font-bold bg-red-100 text-red-700 px-1.5 py-0.5 rounded shrink-0 h-fit">
                          {ctrl.requirement_code}
                        </span>
                        <p className="text-slate-700 truncate flex-1">{ctrl.requirement_text}</p>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {results.length > 0 && (
                <div className="card">
                  <h3 className="text-xs font-semibold text-slate-500 uppercase tracking-wide mb-2">Status mix</h3>
                  <StatusDistribution results={results} />
                </div>
              )}
            </>
          ) : (
            <div className="card text-center py-10">
              <p className="text-slate-500 text-sm">Run analysis to see compliance scores</p>
            </div>
          )}
        </div>
      )}

      {activeTab === 'results' && (
        <div className="card">
          {results.length > 0 ? (
            <>
              <p className="text-xs text-slate-500 mb-4">Click a code for evidence and recommendations.</p>
              <ResultsTable
                results={filteredResults}
                filters={filters}
                onFilterChange={handleFilterChange}
              />
            </>
          ) : (
            <p className="text-center py-10 text-sm text-slate-500">No results yet — run analysis first</p>
          )}
        </div>
      )}
    </div>
  );
}

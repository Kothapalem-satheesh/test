import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { projectsApi } from '../services/api';
import { getErrorMessage } from '../utils/errors';
import CreateProjectModal from '../components/CreateProjectModal';

export default function Dashboard() {
  const [projects, setProjects] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showCreate, setShowCreate] = useState(false);
  const [error, setError] = useState('');

  const loadProjects = async () => {
    try {
      const { data } = await projectsApi.list();
      setProjects(data);
    } catch (err) {
      setError(getErrorMessage(err, 'Failed to load projects'));
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { loadProjects(); }, []);

  const handleCreated = (project) => {
    setProjects([project, ...projects]);
    setShowCreate(false);
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-24">
        <div className="animate-spin rounded-full h-7 w-7 border-2 border-slate-200 border-t-primary-600" />
      </div>
    );
  }

  return (
    <div className="max-w-6xl mx-auto px-4 sm:px-6 py-8">
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">Projects</h1>
        <button onClick={() => setShowCreate(true)} className="btn-primary">New project</button>
      </div>

      {error && (
        <div className="bg-red-50 text-red-700 text-sm p-3 rounded-lg mb-4 border border-red-100">{error}</div>
      )}

      {projects.length === 0 ? (
        <div className="card text-center py-14">
          <p className="text-slate-600 mb-4">No projects yet</p>
          <button onClick={() => setShowCreate(true)} className="btn-primary">Create project</button>
        </div>
      ) : (
        <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
          {projects.map((project) => (
            <Link
              key={project.id}
              to={`/projects/${project.id}`}
              className="card hover:border-primary-200 hover:shadow-md transition-all !p-4"
            >
              <h3 className="font-semibold text-slate-900">{project.name}</h3>
              {project.description && (
                <p className="text-sm text-slate-500 mt-1 line-clamp-2">{project.description}</p>
              )}
              <div className="flex items-center gap-2 mt-3">
                <StatusBadge status={project.analysis_status} />
                {project.selected_frameworks?.length > 0 && (
                  <span className="text-[10px] font-semibold text-slate-400">
                    {project.selected_frameworks.length} frameworks
                  </span>
                )}
              </div>
            </Link>
          ))}
        </div>
      )}

      {showCreate && (
        <CreateProjectModal onClose={() => setShowCreate(false)} onCreated={handleCreated} />
      )}
    </div>
  );
}

function StatusBadge({ status }) {
  const styles = {
    idle: 'bg-slate-100 text-slate-600',
    running: 'bg-blue-50 text-blue-700',
    completed: 'bg-emerald-50 text-emerald-700',
    failed: 'bg-red-50 text-red-700',
  };
  const labels = { idle: 'Not started', running: 'Running', completed: 'Done', failed: 'Failed' };
  return (
    <span className={`text-[10px] font-bold uppercase tracking-wide px-2 py-0.5 rounded ${styles[status] || styles.idle}`}>
      {labels[status] || status}
    </span>
  );
}

import axios from 'axios';
import { supabase } from './supabase';

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:3001/api';

const api = axios.create({
  baseURL: API_URL,
  headers: { 'Content-Type': 'application/json' },
});

api.interceptors.request.use(async (config) => {
  const { data: { session } } = await supabase.auth.getSession();
  if (session?.access_token) {
    config.headers.Authorization = `Bearer ${session.access_token}`;
  }
  return config;
});

// Auth
export const authApi = {
  signup: (data) => api.post('/auth/signup', data),
  login: (data) => api.post('/auth/login', data),
  logout: () => api.post('/auth/logout'),
  me: () => api.get('/auth/me'),
  oauth: (provider) => api.post('/auth/oauth', { provider }),
};

// Projects
export const projectsApi = {
  list: () => api.get('/projects'),
  get: (id) => api.get(`/projects/${id}`),
  create: (data) => api.post('/projects', data),
  update: (id, data) => api.put(`/projects/${id}`, data),
  delete: (id) => api.delete(`/projects/${id}`),
  scores: (id) => api.get(`/projects/${id}/scores`),
};

// Documents
export const documentsApi = {
  list: (projectId) => api.get(`/documents/project/${projectId}`),
  upload: (projectId, files, onProgress) => {
    const formData = new FormData();
    files.forEach((f) => formData.append('files', f));
    return api.post(`/documents/upload/${projectId}`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
      onUploadProgress: onProgress,
    });
  },
  chunks: (id) => api.get(`/documents/${id}/chunks`),
  reprocess: (id) => api.post(`/documents/${id}/reprocess`),
  delete: (id) => api.delete(`/documents/${id}`),
};

// Frameworks
export const frameworksApi = {
  list: () => api.get('/frameworks'),
  requirements: (id) => api.get(`/frameworks/${id}/requirements`),
};

// Analysis
export const analysisApi = {
  start: (projectId, frameworkIds) => api.post(`/analysis/start/${projectId}`, { framework_ids: frameworkIds }),
  status: (projectId) => api.get(`/analysis/status/${projectId}`),
  results: (projectId, params) => api.get(`/analysis/results/${projectId}`, { params }),
  result: (resultId) => api.get(`/analysis/result/${resultId}`),
  rerun: (projectId, frameworkIds) => api.post(`/analysis/rerun/${projectId}`, { framework_ids: frameworkIds }),
};

// Reports
export const reportsApi = {
  generate: (projectId, type) => api.post(`/reports/generate/${projectId}`, { type }),
  download: (projectId, type) => api.get(`/reports/download/${projectId}/${type}`, { responseType: 'blob' }),
  history: (projectId) => api.get(`/reports/history/${projectId}`),
};

// Health
export const healthApi = {
  check: () => api.get('/health'),
};

export default api;

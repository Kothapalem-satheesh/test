import axios from 'axios';
import FormData from 'form-data';
import { config } from '../config/index.js';

const pythonClient = axios.create({
  baseURL: config.pythonServiceUrl,
  timeout: 120000,
  headers: {
    'X-Internal-Secret': config.internalSecret,
  },
});

/**
 * Health check for Python microservice
 */
export async function checkPythonHealth() {
  const { data } = await pythonClient.get('/health');
  return data;
}

/**
 * Extract text chunks from a file buffer
 * @param {Buffer} fileBuffer
 * @param {string} filename
 * @param {string} fileType
 * @returns {Promise<{chunks: Array}>}
 */
export async function extractDocument(fileBuffer, filename, fileType) {
  const form = new FormData();
  form.append('file', fileBuffer, { filename, contentType: getMimeType(fileType) });

  const { data } = await pythonClient.post('/extract', form, {
    headers: form.getHeaders(),
  });
  return data;
}

/**
 * Generate embeddings for a list of text strings (batched for large documents).
 */
export async function generateEmbeddings(texts) {
  const batchSize = config.embedBatchSize;
  const allEmbeddings = [];

  for (let i = 0; i < texts.length; i += batchSize) {
    const batch = texts.slice(i, i + batchSize);
    const { data } = await pythonClient.post('/embed', { texts: batch });
    allEmbeddings.push(...(data.embeddings || []));
  }

  return {
    embeddings: allEmbeddings,
    model: 'batched',
    dimensions: allEmbeddings[0]?.length || 384,
  };
}

function getMimeType(fileType) {
  const types = {
    pdf: 'application/pdf',
    docx: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    txt: 'text/plain',
    md: 'text/markdown',
    xlsx: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  };
  return types[fileType] || 'application/octet-stream';
}

export default pythonClient;

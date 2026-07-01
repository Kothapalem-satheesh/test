import { Router } from 'express';
import { checkPythonHealth } from '../services/pythonServiceClient.js';
import { getLlmProviderInfo } from '../services/llmService.js';

const router = Router();

router.get('/', async (req, res, next) => {
  try {
    let pythonStatus = 'unreachable';
    let pythonDetails = null;

    try {
      pythonDetails = await checkPythonHealth();
      pythonStatus = 'healthy';
    } catch (err) {
      pythonDetails = { error: err.message };
    }

    res.json({
      status: 'ok',
      service: 'complianceai-server',
      timestamp: new Date().toISOString(),
      python_service: pythonStatus,
      python_details: pythonDetails,
      llm: getLlmProviderInfo(),
    });
  } catch (err) {
    next(err);
  }
});

export default router;

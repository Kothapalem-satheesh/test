import { Router } from 'express';
import { authenticate } from '../middleware/auth.js';
import { supabasePublic } from '../config/supabase.js';

const router = Router();

router.get('/', authenticate, async (req, res, next) => {
  try {
    const { data, error } = await supabasePublic
      .from('frameworks')
      .select('*, requirements(count)')
      .order('name');

    if (error) throw error;
    res.json(data);
  } catch (err) {
    next(err);
  }
});

router.get('/:id/requirements', authenticate, async (req, res, next) => {
  try {
    const { data, error } = await supabasePublic
      .from('requirements')
      .select('id, requirement_code, category, requirement_text, severity, keywords')
      .eq('framework_id', req.params.id)
      .order('requirement_code');

    if (error) throw error;
    res.json(data);
  } catch (err) {
    next(err);
  }
});

export default router;

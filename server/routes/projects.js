import { Router } from 'express';
import { authenticate } from '../middleware/auth.js';
import { calculateScores } from '../services/scoringEngine.js';

const router = Router();
router.use(authenticate);

router.get('/', async (req, res, next) => {
  try {
    const { data, error } = await req.supabase
      .from('projects')
      .select('*')
      .order('created_at', { ascending: false });

    if (error) throw error;
    res.json(data);
  } catch (err) {
    next(err);
  }
});

router.post('/', async (req, res, next) => {
  try {
    const { name, description, selected_frameworks } = req.body;
    if (!name?.trim()) {
      return res.status(400).json({ error: 'Project name is required' });
    }

    const { data, error } = await req.supabase
      .from('projects')
      .insert({
        user_id: req.user.id,
        name: name.trim(),
        description: description || '',
        selected_frameworks: selected_frameworks || [],
      })
      .select()
      .single();

    if (error) throw error;
    res.status(201).json(data);
  } catch (err) {
    next(err);
  }
});

router.get('/:id', async (req, res, next) => {
  try {
    const { data, error } = await req.supabase
      .from('projects')
      .select('*')
      .eq('id', req.params.id)
      .single();

    if (error || !data) {
      return res.status(404).json({ error: 'Project not found' });
    }
    res.json(data);
  } catch (err) {
    next(err);
  }
});

router.put('/:id', async (req, res, next) => {
  try {
    const { name, description, selected_frameworks } = req.body;
    const updates = { updated_at: new Date().toISOString() };
    if (name) updates.name = name.trim();
    if (description !== undefined) updates.description = description;
    if (selected_frameworks) updates.selected_frameworks = selected_frameworks;

    const { data, error } = await req.supabase
      .from('projects')
      .update(updates)
      .eq('id', req.params.id)
      .select()
      .single();

    if (error || !data) {
      return res.status(404).json({ error: 'Project not found' });
    }
    res.json(data);
  } catch (err) {
    next(err);
  }
});

router.delete('/:id', async (req, res, next) => {
  try {
    const { error } = await req.supabase
      .from('projects')
      .delete()
      .eq('id', req.params.id);

    if (error) throw error;
    res.json({ message: 'Project deleted' });
  } catch (err) {
    next(err);
  }
});

router.get('/:id/scores', async (req, res, next) => {
  try {
    const { data: project } = await req.supabase
      .from('projects')
      .select('id')
      .eq('id', req.params.id)
      .single();

    if (!project) return res.status(404).json({ error: 'Project not found' });

    const { data: results, error } = await req.supabase
      .from('compliance_results')
      .select('*, requirement:requirements(*, framework:frameworks(name))')
      .eq('project_id', req.params.id);

    if (error) throw error;

    const scores = calculateScores(results || []);
    res.json(scores);
  } catch (err) {
    next(err);
  }
});

export default router;

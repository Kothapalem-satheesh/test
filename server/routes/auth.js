import { Router } from 'express';
import { supabaseAuth } from '../config/supabase.js';
import { authenticate } from '../middleware/auth.js';

const router = Router();

router.post('/signup', async (req, res, next) => {
  try {
    const { email, password, fullName } = req.body;
    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password required' });
    }

    const { data, error } = await supabaseAuth.auth.signUp({
      email,
      password,
      options: { data: { full_name: fullName } },
    });

    if (error) {
      const message = typeof error.message === 'string' && error.message !== '{}'
        ? error.message
        : (error.msg || error.code || 'Authentication failed');
      return res.status(400).json({ error: message });
    }

    res.status(201).json({
      user: { id: data.user?.id, email: data.user?.email },
      session: data.session,
      message: data.session ? 'Account created' : 'Check email for confirmation',
    });
  } catch (err) {
    next(err);
  }
});

router.post('/login', async (req, res, next) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password required' });
    }

    const { data, error } = await supabaseAuth.auth.signInWithPassword({ email, password });
    if (error) {
      const message = typeof error.message === 'string' && error.message !== '{}'
        ? error.message
        : (error.msg || error.code || 'Authentication failed');
      return res.status(401).json({ error: message });
    }

    res.json({
      user: { id: data.user.id, email: data.user.email },
      session: data.session,
    });
  } catch (err) {
    next(err);
  }
});

router.post('/logout', authenticate, async (req, res, next) => {
  try {
    await supabaseAuth.auth.signOut();
    res.json({ message: 'Logged out' });
  } catch (err) {
    next(err);
  }
});

router.get('/me', authenticate, async (req, res) => {
  res.json({ user: req.user });
});

router.post('/oauth', async (req, res, next) => {
  try {
    const { provider = 'google' } = req.body;
    const { data, error } = await supabaseAuth.auth.signInWithOAuth({
      provider,
      options: {
        redirectTo: `${process.env.CLIENT_URL || 'http://localhost:5173'}/auth/callback`,
      },
    });
    if (error) {
      const message = typeof error.message === 'string' && error.message !== '{}'
        ? error.message
        : (error.msg || error.code || 'Authentication failed');
      return res.status(400).json({ error: message });
    }
    res.json({ url: data.url });
  } catch (err) {
    next(err);
  }
});

export default router;

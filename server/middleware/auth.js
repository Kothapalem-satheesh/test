import { supabaseAuth, createUserClient } from '../config/supabase.js';

/**
 * Verifies Supabase JWT from Authorization header.
 * Attaches req.user and req.supabase (user-scoped client) on success.
 */
export async function authenticate(req, res, next) {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'Missing or invalid authorization header' });
    }

    const token = authHeader.slice(7);
    const { data: { user }, error } = await supabaseAuth.auth.getUser(token);

    if (error || !user) {
      return res.status(401).json({ error: error?.message || 'Invalid or expired token' });
    }

    req.user = { id: user.id, email: user.email };
    req.accessToken = token;
    req.supabase = createUserClient(token);
    next();
  } catch (err) {
    next(err);
  }
}

import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.SUPABASE_URL || '';
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY || '';
const supabaseAnonKey = process.env.SUPABASE_ANON_KEY || '';

const isPlaceholderKey = (key) =>
  !key || key === 'your-service-role-key' || key === 'your-anon-key';

export const isServiceRoleConfigured = Boolean(supabaseUrl && !isPlaceholderKey(supabaseServiceKey));

if (!supabaseUrl || isPlaceholderKey(supabaseAnonKey)) {
  console.warn('Warning: Supabase URL or anon/publishable key not configured');
}
if (!isServiceRoleConfigured) {
  console.warn('Warning: SUPABASE_SERVICE_ROLE_KEY not set — using user-scoped clients for CRUD; uploads/analysis need the secret key');
}

/** Admin client with service role - bypasses RLS for server operations */
export const supabaseAdmin = isServiceRoleConfigured
  ? createClient(supabaseUrl, supabaseServiceKey, {
      auth: { autoRefreshToken: false, persistSession: false },
    })
  : null;

/** Client for verifying user JWTs */
export const supabaseAuth = createClient(supabaseUrl, supabaseAnonKey, {
  auth: { autoRefreshToken: false, persistSession: false },
});

/** Public read client (frameworks, requirements) */
export const supabasePublic = createClient(supabaseUrl, supabaseAnonKey, {
  auth: { autoRefreshToken: false, persistSession: false },
});

/**
 * Create a Supabase client scoped to the authenticated user's JWT.
 * Works with publishable keys and respects RLS.
 */
export function createUserClient(accessToken) {
  return createClient(supabaseUrl, supabaseAnonKey, {
    global: {
      headers: { Authorization: `Bearer ${accessToken}` },
    },
    auth: {
      autoRefreshToken: false,
      persistSession: false,
      detectSessionInUrl: false,
    },
  });
}

export const STORAGE_BUCKET = process.env.SUPABASE_STORAGE_BUCKET || 'documents';

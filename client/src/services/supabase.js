import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || '';
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || '';

export const isSupabaseConfigured =
  Boolean(supabaseUrl && supabaseAnonKey) &&
  !supabaseUrl.includes('your-project') &&
  supabaseAnonKey !== 'your-anon-key';

function createSupabaseClient() {
  if (!isSupabaseConfigured) {
    // Prevent crash on import; auth calls will no-op until real keys are set
    return createClient('https://placeholder.supabase.co', 'placeholder-anon-key');
  }
  return createClient(supabaseUrl, supabaseAnonKey);
}

export const supabase = createSupabaseClient();

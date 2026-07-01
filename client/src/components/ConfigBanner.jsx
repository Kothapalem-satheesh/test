import { isSupabaseConfigured } from '../services/supabase';

export default function ConfigBanner() {
  if (isSupabaseConfigured) return null;

  return (
    <div className="bg-amber-50 border-b border-amber-200 px-4 py-2 text-center text-sm text-amber-900">
      Supabase is not configured. Add your keys to <code className="bg-amber-100 px-1 rounded">.env</code> and restart the client to enable login.
    </div>
  );
}

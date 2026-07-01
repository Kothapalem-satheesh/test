import { createContext, useContext, useState, useEffect } from 'react';
import { supabase, isSupabaseConfigured } from '../services/supabase';
import { getErrorMessage } from '../utils/errors';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!isSupabaseConfigured) {
      setLoading(false);
      return undefined;
    }

    supabase.auth.getSession()
      .then(({ data: { session } }) => {
        setUser(session?.user ? { id: session.user.id, email: session.user.email } : null);
      })
      .catch(() => setUser(null))
      .finally(() => setLoading(false));

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ? { id: session.user.id, email: session.user.email } : null);
    });

    return () => subscription.unsubscribe();
  }, []);

  const signup = async (email, password, fullName) => {
    if (!isSupabaseConfigured) {
      throw new Error('Supabase is not configured. Check your .env file.');
    }

    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: { data: { full_name: fullName } },
    });

    if (error) throw new Error(error.message || 'Signup failed');

    if (data.session && data.user) {
      setUser({ id: data.user.id, email: data.user.email });
    }

    return {
      user: data.user,
      session: data.session,
      message: data.session ? 'Account created' : 'Check your email to confirm your account',
    };
  };

  const login = async (email, password) => {
    if (!isSupabaseConfigured) {
      throw new Error('Supabase is not configured. Check your .env file.');
    }

    const { data, error } = await supabase.auth.signInWithPassword({ email, password });

    if (error) throw new Error(error.message || 'Login failed');

    const authUser = { id: data.user.id, email: data.user.email };
    setUser(authUser);
    return { user: authUser, session: data.session };
  };

  const loginWithGoogle = async () => {
    if (!isSupabaseConfigured) {
      throw new Error('Supabase is not configured. Check your .env file.');
    }

    const { data, error } = await supabase.auth.signInWithOAuth({
      provider: 'google',
      options: { redirectTo: `${window.location.origin}/auth/callback` },
    });

    if (error) throw new Error(error.message || 'OAuth failed');
    if (data.url) window.location.href = data.url;
  };

  const logout = async () => {
    await supabase.auth.signOut();
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, loading, signup, login, loginWithGoogle, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) throw new Error('useAuth must be used within AuthProvider');
  return context;
}

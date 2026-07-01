/**
 * Extract a human-readable message from API or Supabase errors.
 */
export function getErrorMessage(err, fallback = 'Something went wrong') {
  if (!err) return fallback;
  if (typeof err === 'string') return err;

  const apiError = err.response?.data?.error;
  if (typeof apiError === 'string' && apiError && apiError !== '{}') return apiError;
  if (apiError?.message) return apiError.message;

  if (err.message && err.message !== '{}') return err.message;
  if (err.error_description) return err.error_description;

  return fallback;
}

export function errorHandler(err, req, res, _next) {
  console.error('Error:', err.message || err, err.code || '');

  const status = err.status || err.statusCode || 500;
  const message = err.message || err.details || err.hint || 'Internal server error';

  res.status(status).json({
    error: message,
    ...(process.env.NODE_ENV === 'development' && { code: err.code, stack: err.stack }),
  });
}

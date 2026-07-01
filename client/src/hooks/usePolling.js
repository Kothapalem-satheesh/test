import { useEffect, useRef } from 'react';

/**
 * Poll a callback at a given interval while `active` is true.
 */
export function usePolling(callback, intervalMs = 3000, active = true) {
  const savedCallback = useRef(callback);

  useEffect(() => {
    savedCallback.current = callback;
  }, [callback]);

  useEffect(() => {
    if (!active) return;
    const tick = () => savedCallback.current();
    const id = setInterval(tick, intervalMs);
    return () => clearInterval(id);
  }, [intervalMs, active]);
}

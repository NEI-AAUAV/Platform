const RETRY_DELAYS_MS = [300, 1000];
const RELOAD_FLAG = "lazy-route-reloaded";

const wait = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

/**
 * Wrap a dynamic route import so transient failures (dev server restart,
 * re-optimized deps, stale chunk hashes after a deploy) retry, then reload once.
 */
export function lazyRoute(importer) {
  return async () => {
    const mod = await load(importer);
    sessionStorage.removeItem(RELOAD_FLAG);
    return mod;
  };
}

function load(importer) {
  return (async () => {
    for (const delay of RETRY_DELAYS_MS) {
      try {
        return await importer();
      } catch {
        await wait(delay);
      }
    }
    try {
      return await importer();
    } catch (error) {
      if (!sessionStorage.getItem(RELOAD_FLAG)) {
        sessionStorage.setItem(RELOAD_FLAG, "1");
        window.location.reload();
        return new Promise(() => {});
      }
      throw error;
    }
  })();
}

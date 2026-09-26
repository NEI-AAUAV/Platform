import { useEffect, useState } from "react";

const PROBE_TIMEOUT_MS = 4000;
const DEFAULT_INTERVAL_MS = 60000;

/**
 * Probes a single URL for reachability without requiring CORS to be
 * configured on the target - `no-cors` mode still lets the browser attempt
 * the request and resolve/reject on network-level success/failure, even
 * though the response body itself is opaque and unreadable.
 *
 * @param {string} url
 * @returns {Promise<boolean>} true if reachable, false otherwise
 */
async function probe(url) {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), PROBE_TIMEOUT_MS);
  try {
    await fetch(url, {
      mode: "no-cors",
      cache: "no-store",
      signal: controller.signal,
    });
    return true;
  } catch (_) {
    return false;
  } finally {
    clearTimeout(timeoutId);
  }
}

/**
 * Tracks aggregate reachability of one or more external service URLs.
 * Meant for services outside the platform (Rally, Gamification) that are no
 * longer embedded extensions and can't be trusted to expose readable
 * health JSON across origins.
 *
 * @param {string[]} targets - URLs to probe (e.g. web root + per-microservice health endpoints)
 * @param {{ intervalMs?: number }} [options]
 * @returns {"checking" | "up" | "degraded" | "down"}
 */
export function useServiceHealth(targets, { intervalMs = DEFAULT_INTERVAL_MS } = {}) {
  const [status, setStatus] = useState("checking");
  const targetsKey = Array.isArray(targets) ? targets.filter(Boolean).join("|") : "";

  useEffect(() => {
    const activeTargets = targetsKey ? targetsKey.split("|") : [];
    if (activeTargets.length === 0) {
      setStatus("checking");
      return;
    }

    let cancelled = false;

    const check = async () => {
      const results = await Promise.all(activeTargets.map(probe));
      if (cancelled) return;
      const reachable = results.filter(Boolean).length;
      if (reachable === 0) setStatus("down");
      else if (reachable === activeTargets.length) setStatus("up");
      else setStatus("degraded");
    };

    check();
    const intervalId = setInterval(check, intervalMs);
    return () => {
      cancelled = true;
      clearInterval(intervalId);
    };
  }, [targetsKey, intervalMs]);

  return status;
}

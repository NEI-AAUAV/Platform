import React, { useCallback, useEffect, useState } from "react";
import service from "services/NEIService";
import { formatDateTime } from "../formatDate";

const PAGE_SIZE = 50;

const ARRAIAL_SETTING_LABELS = {
  enabled: "Arraial page",
  paused: "pause",
  boosts_enabled: "boosts",
  milestones_enabled: "Shot Capacete milestones",
};

export function describeActivity(entry) {
  const target = entry.target_name ?? "a deleted account";
  const detail = entry.detail ?? {};
  switch (entry.action) {
    case "role.add":
      return `gave ${target} the ${detail.role} role`;
    case "role.remove":
      return `removed the ${detail.role} role from ${target}`;
    case "sessions.revoke": {
      const n = detail.sessions ?? 0;
      return `signed ${target} out everywhere (${n} session${n === 1 ? "" : "s"} ended)`;
    }
    case "arraial.config": {
      const changes = Object.entries(detail).map(
        ([field, on]) => `${ARRAIAL_SETTING_LABELS[field] ?? field} ${on ? "on" : "off"}`
      );
      return `changed Arraial settings: ${changes.join(", ")}`;
    }
    case "arraial.reset":
      return "reset Arraial";
    default:
      return entry.action;
  }
}

export default function Activity() {
  const [items, setItems] = useState([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const load = useCallback((offset) => {
    setLoading(true);
    service
      .getAdminActivity(offset, PAGE_SIZE)
      .then((page) => {
        setItems((prev) => (offset === 0 ? page.items : [...prev, ...page.items]));
        setTotal(page.total);
        setError(null);
      })
      .catch((e) => {
        console.error("Failed to load admin activity:", e);
        setError(`Failed to load activity: ${e?.message || "Unknown error"}`);
      })
      .finally(() => setLoading(false));
  }, []);

  useEffect(() => {
    load(0);
  }, [load]);

  return (
    <div className="flex flex-col gap-3">
      <p className="text-sm opacity-70">
        Role changes, sign-outs and Arraial changes made by admins. Content edits are logged in the
        CMS.
      </p>

      {error && (
        <div className="alert alert-error" role="alert">
          <span>{error}</span>
        </div>
      )}

      {!loading && !error && items.length === 0 && (
        <div className="rounded bg-base-200 p-3 text-sm opacity-70">Nothing recorded yet.</div>
      )}

      {items.length > 0 && (
        <ol className="rounded bg-base-200 divide-y divide-base-300">
          {items.map((entry) => (
            <li key={entry.id} className="flex flex-col gap-0.5 p-3 sm:flex-row sm:gap-4">
              <time
                dateTime={entry.created_at}
                className="shrink-0 text-xs opacity-70 sm:w-44 sm:text-sm"
              >
                {formatDateTime(entry.created_at)}
              </time>
              <span className="text-sm">
                <strong>{entry.actor_name ?? "Unknown admin"}</strong> {describeActivity(entry)}
              </span>
            </li>
          ))}
        </ol>
      )}

      {loading && <div className="text-sm opacity-70">Loading activity…</div>}

      {!loading && items.length < total && (
        <button className="btn btn-outline btn-sm self-start" onClick={() => load(items.length)}>
          Load older entries
        </button>
      )}
    </div>
  );
}

import React from "react";

export default function HistoryList({
  log,
  logLoading,
  nextOffset,
  LOG_PAGE_SIZE,
  onLoadMore,
  onRollback,
}) {
  return (
    <div className="mt-2 rounded bg-base-100 p-2">
      <div className="max-h-64 overflow-auto rounded">
        {logLoading ? (
          <div className="text-sm opacity-70 p-2">Loading…</div>
        ) : log.length === 0 ? (
          <div className="text-sm opacity-70 p-2">No changes.</div>
        ) : (
          <>
            <ul className="space-y-1 text-sm">
              {log.map((e) => (
                <li
                  key={e.id}
                  className="flex items-center justify-between rounded px-2 py-1 hover:bg-base-200"
                >
                  {e.event === "BOOST_ACTIVATED" ? (
                    <>
                      <span>
                        <strong>{e.nucleo}</strong>{" "}
                        <span className="badge badge-warning badge-sm align-middle">
                          1.25x Boost
                        </span>
                        {e.timestamp && (
                          <span className="ml-2 opacity-60">
                            {new Date(e.timestamp).toLocaleString()}
                          </span>
                        )}
                        {e.user_email && (
                          <span className="ml-2 opacity-70">{e.user_email}</span>
                        )}
                      </span>
                      <button
                        className="btn btn-sm sm:btn-xs"
                        disabled={!!e.rolled_back}
                        onClick={() => onRollback(e.id)}
                      >
                        Undo
                      </button>
                    </>
                  ) : (
                    <>
                      <span>
                        <strong>{e.nucleo}</strong>{" "}
                        <span className={e.delta >= 0 ? "text-success" : "text-error"}>
                          {e.delta >= 0 ? `+${e.delta}` : e.delta}
                        </span>{" "}
                        <span className="opacity-70">
                          ({e.prev_value} → {e.new_value})
                        </span>
                        {e.user_email && (
                          <span className="ml-2 opacity-70">{e.user_email}</span>
                        )}
                        {!e.user_email && e.user_id !== null && (
                          <span className="ml-2 opacity-60">user #{e.user_id}</span>
                        )}
                        {e.timestamp && (
                          <span className="ml-2 opacity-60">
                            {new Date(e.timestamp).toLocaleString()}
                          </span>
                        )}
                        {e.rolled_back && (
                          <span className="ml-2 badge badge-outline">rolled back</span>
                        )}
                      </span>
                      <button
                        className="btn btn-sm sm:btn-xs"
                        disabled={!!e.rolled_back}
                        onClick={() => onRollback(e.id)}
                      >
                        Undo
                      </button>
                    </>
                  )}
                </li>
              ))}
            </ul>
            {nextOffset != null && log.length >= LOG_PAGE_SIZE && (
              <div className="mt-2 flex justify-center">
                <button className="btn btn-xs" disabled={logLoading} onClick={onLoadMore}>
                  Load more
                </button>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
}

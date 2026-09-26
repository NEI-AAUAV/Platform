import React from "react";

export default function HistorySkeleton() {
  return (
    <div className="history-page" aria-busy="true" aria-live="polite">
      <div className="history-skeleton history-skeleton--hero" />
      <div className="history-skeleton-list">
        {Array.from({ length: 4 }).map((_, i) => (
          <div key={i} className="history-skeleton history-skeleton--card" />
        ))}
      </div>
    </div>
  );
}

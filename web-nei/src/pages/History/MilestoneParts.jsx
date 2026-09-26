import React from "react";
import ReactMarkdown from "react-markdown";

import MaterialSymbol from "components/MaterialSymbol";

import { formatMilestoneDate, galleryCount, hasGallery } from "./utils";

/** Pieces shared by `MilestoneCard` and `FeaturedMilestone`, which differ
 * only in layout and emphasis. */

export function MilestoneMeta({ milestone, children }) {
  const category = milestone.category;
  return (
    <div className="history-card__meta">
      {children}
      <time dateTime={milestone.moment}>{formatMilestoneDate(milestone.moment)}</time>
      {category && (
        <span
          className="history-chip"
          style={{ "--chip-color": category.color || "hsl(var(--muted-foreground))" }}
        >
          {category.label}
        </span>
      )}
    </div>
  );
}

export function MilestoneText({ milestone }) {
  return (
    <>
      <h3>{milestone.title}</h3>
      {milestone.body && (
        <div className="history-card__text">
          <ReactMarkdown>{milestone.body}</ReactMarkdown>
        </div>
      )}
    </>
  );
}

export function MilestoneActions({ milestone, onOpenGallery }) {
  const count = galleryCount(milestone);
  const showGallery = hasGallery(milestone);
  if (!showGallery && !milestone.external_url) return null;

  return (
    <div className="history-card__actions">
      {showGallery && (
        <button
          type="button"
          className="history-card__gallery-btn"
          onClick={() => onOpenGallery(milestone)}
        >
          <MaterialSymbol icon="photo_library" size={18} />
          Ver galeria
          {count !== null && (
            <span className="history-card__gallery-count">
              ({count} {count === 1 ? "foto" : "fotos"})
            </span>
          )}
        </button>
      )}
      {milestone.external_url && (
        <a
          href={milestone.external_url}
          target="_blank"
          rel="noreferrer"
          className="history-card__external-link"
        >
          {milestone.external_label || "Saber mais"}
          <MaterialSymbol icon="open_in_new" size={16} />
        </a>
      )}
    </div>
  );
}

export function CoverImage({ src, width, height }) {
  return (
    <img
      src={src}
      alt=""
      width={width}
      height={height}
      loading="lazy"
      decoding="async"
      onError={(e) => {
        e.currentTarget.style.display = "none";
      }}
    />
  );
}

import React from "react";
import ReactMarkdown from "react-markdown";

import MaterialSymbol from "components/MaterialSymbol";

import { categoryStyle, formatMilestoneDate, galleryCount, hasGallery } from "./utils";

/** Pieces shared by `MilestoneCard` and `FeaturedMilestone`, which differ
 * only in layout and emphasis. */

export function MilestoneMeta({ milestone, children }) {
  const category = milestone.category;
  return (
    <div className="history-card__meta">
      {children}
      <time dateTime={milestone.moment}>{formatMilestoneDate(milestone.moment)}</time>
      {category && (
        <span className="history-chip" style={categoryStyle(category)}>
          {category.label}
        </span>
      )}
    </div>
  );
}

/** The card's title is an h3, so body headings — whatever level the editor
 * typed — become one smaller card-level heading instead of competing with
 * the page's h1/h2 outline. */
function BodyHeading({ node: _node, ...props }) {
  return <h4 className="history-card__text-heading" {...props} />;
}

function BodyLink({ node: _node, href, children, ...props }) {
  return (
    <a {...props} href={href} target="_blank" rel="noopener noreferrer">
      {children}
    </a>
  );
}

const BODY_COMPONENTS = {
  h1: BodyHeading,
  h2: BodyHeading,
  h3: BodyHeading,
  h4: BodyHeading,
  h5: BodyHeading,
  h6: BodyHeading,
  a: BodyLink,
};

// Remote images would be hotlinked from any host and can break the card
// layout; photos belong in the gallery (history_media / Drive folder).
const BODY_DISALLOWED = ["img"];

export function MilestoneBody({ children }) {
  return (
    <div className="history-card__text">
      {/* skipHtml: no raw HTML from the CMS reaches the page. Link hrefs go
          through react-markdown's default URL sanitiser (no javascript:). */}
      <ReactMarkdown
        skipHtml
        components={BODY_COMPONENTS}
        disallowedElements={BODY_DISALLOWED}
      >
        {children}
      </ReactMarkdown>
    </div>
  );
}

export function MilestoneText({ milestone }) {
  return (
    <>
      <h3>{milestone.title}</h3>
      {milestone.body && <MilestoneBody>{milestone.body}</MilestoneBody>}
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

/** `alt` is what an editor wrote for the image (`cover_alt`); without one
 * the cover is treated as decorative: it sits right beside the milestone's
 * title, and a made-up description would be worse than none. */
export function CoverImage({ src, alt, width, height }) {
  return (
    <img
      src={src}
      alt={alt || ""}
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

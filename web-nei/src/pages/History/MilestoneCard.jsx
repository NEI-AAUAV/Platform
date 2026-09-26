import React from "react";
import { motion, useReducedMotion } from "framer-motion";
import ReactMarkdown from "react-markdown";

import MaterialSymbol from "components/MaterialSymbol";

import { formatMilestoneDate } from "./utils";

export default function MilestoneCard({ milestone, onOpenGallery }) {
  const reducedMotion = useReducedMotion();
  const meta = milestone.category;
  const cover = milestone.image || milestone.media[0]?.thumb;
  const galleryCount =
    milestone.media.length + (milestone.has_drive_gallery ? 1 : 0);

  return (
    <motion.article
      id={`marco-${milestone.id}`}
      className="history-card"
      initial={reducedMotion ? false : { opacity: 0, y: 24 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, margin: "-80px" }}
      transition={{ duration: 0.4 }}
    >
      {cover && (
        <div className="history-card__cover">
          <img
            src={cover}
            alt=""
            width={480}
            height={270}
            loading="lazy"
            onError={(e) => {
              e.currentTarget.style.display = "none";
            }}
          />
        </div>
      )}

      <div className="history-card__body">
        <div className="history-card__meta">
          <time dateTime={milestone.moment}>
            {formatMilestoneDate(milestone.moment)}
          </time>
          {meta && (
            <span
              className="history-chip"
              style={{ "--chip-color": meta.color || "hsl(var(--muted-foreground))" }}
            >
              {meta.label}
            </span>
          )}
        </div>

        <h3>{milestone.title}</h3>

        {milestone.body && (
          <div className="history-card__text">
            <ReactMarkdown>{milestone.body}</ReactMarkdown>
          </div>
        )}

        <div className="history-card__actions">
          {galleryCount > 0 && (
            <button
              type="button"
              className="history-card__gallery-btn"
              onClick={() => onOpenGallery(milestone)}
            >
              <MaterialSymbol icon="photo_library" size={18} />
              Ver galeria
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
      </div>
    </motion.article>
  );
}

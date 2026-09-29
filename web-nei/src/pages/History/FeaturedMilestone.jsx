import React from "react";
import { motion, useReducedMotion } from "framer-motion";

import MaterialSymbol from "components/MaterialSymbol";

import { CoverImage, MilestoneActions, MilestoneMeta, MilestoneText } from "./MilestoneParts";
import { coverOrPlaceholder } from "./utils";

function FeaturedBadge({ overlay }) {
  return (
    <span
      className={
        overlay
          ? "history-featured__badge history-featured__badge--overlay"
          : "history-featured__badge"
      }
    >
      <MaterialSymbol icon="star" size={16} />
      Em destaque
    </span>
  );
}

export default function FeaturedMilestone({ milestone, onOpenGallery }) {
  const reducedMotion = useReducedMotion();
  const cover = coverOrPlaceholder(milestone, 1200, 600);

  return (
    <motion.article
      id={`marco-${milestone.id}`}
      className="history-featured"
      initial={reducedMotion ? false : { opacity: 0, y: 32 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, margin: "-100px" }}
      transition={{ duration: 0.5 }}
    >
      {cover && (
        <>
          <FeaturedBadge overlay />
          <div className="history-featured__cover">
            <CoverImage src={cover} alt={milestone.cover_alt} width={1200} height={600} />
          </div>
        </>
      )}

      <div className="history-featured__body">
        <MilestoneMeta milestone={milestone}>
          {!cover && <FeaturedBadge />}
        </MilestoneMeta>
        <MilestoneText milestone={milestone} />
        <MilestoneActions milestone={milestone} onOpenGallery={onOpenGallery} />
      </div>
    </motion.article>
  );
}

import React from "react";
import { motion, useReducedMotion } from "framer-motion";

import { CoverImage, MilestoneActions, MilestoneMeta, MilestoneText } from "./MilestoneParts";
import { coverOrPlaceholder, placeholderCover } from "./utils";

export default function MilestoneCard({ milestone, onOpenGallery }) {
  const reducedMotion = useReducedMotion();
  const cover = coverOrPlaceholder(milestone, 480, 270);

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
          <CoverImage src={cover} alt={milestone.cover_alt}
            width={480}
            height={270}
            fallbackSrc={placeholderCover(milestone, 480, 270)}
          />
        </div>
      )}

      <div className="history-card__body">
        <MilestoneMeta milestone={milestone} />
        <MilestoneText milestone={milestone} />
        <MilestoneActions milestone={milestone} onOpenGallery={onOpenGallery} />
      </div>
    </motion.article>
  );
}

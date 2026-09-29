import React, { useEffect, useRef } from "react";

import MilestoneCard from "./MilestoneCard";
import FeaturedMilestone from "./FeaturedMilestone";
import { mandateAnchorId } from "./utils";

export default function MandateSection({
  mandate,
  milestones,
  featuredIds,
  onMandateVisible,
  onOpenGallery,
}) {
  const ref = useRef(null);

  useEffect(() => {
    const el = ref.current;
    if (!el || !onMandateVisible) return undefined;

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) onMandateVisible(mandate);
      },
      { rootMargin: "-40% 0px -50% 0px" }
    );
    observer.observe(el);
    return () => observer.disconnect();
  }, [mandate, onMandateVisible]);

  return (
    <section
      id={mandateAnchorId(mandate)}
      ref={ref}
      className="history-year-section"
      aria-labelledby={`${mandateAnchorId(mandate)}-heading`}
    >
      <header className="history-year-section__header">
        <h2 id={`${mandateAnchorId(mandate)}-heading`}>{mandate}</h2>
        <span className="history-year-section__mandate">Mandato</span>
      </header>

      <div className="history-year-section__items">
        {milestones.map((milestone) =>
          featuredIds.has(milestone.id) ? (
            <FeaturedMilestone
              key={milestone.id}
              milestone={milestone}
              onOpenGallery={onOpenGallery}
            />
          ) : (
            <MilestoneCard
              key={milestone.id}
              milestone={milestone}
              onOpenGallery={onOpenGallery}
            />
          )
        )}
      </div>
    </section>
  );
}

import React, { useEffect, useRef } from "react";

import MilestoneCard from "./MilestoneCard";
import FeaturedMilestone from "./FeaturedMilestone";
import { mandateLabel } from "./utils";

export default function YearSection({
  year,
  milestones,
  featuredIds,
  onYearVisible,
  onOpenGallery,
}) {
  const ref = useRef(null);

  useEffect(() => {
    const el = ref.current;
    if (!el || !onYearVisible) return undefined;

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) onYearVisible(year);
      },
      { rootMargin: "-40% 0px -50% 0px" }
    );
    observer.observe(el);
    return () => observer.disconnect();
  }, [year, onYearVisible]);

  return (
    <section
      id={`history-year-${year}`}
      ref={ref}
      className="history-year-section"
    >
      <header className="history-year-section__header">
        <h2>{year}</h2>
        <span className="history-year-section__mandate">
          {mandateLabel(milestones[0])}
        </span>
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

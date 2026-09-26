import React, { useEffect, useMemo, useState } from "react";
import { useSearchParams } from "react-router-dom";

import service from "services/NEIService";

import HistoryHero from "./HistoryHero";
import CategoryFilter from "./CategoryFilter";
import MobileFilterBar from "./MobileFilterBar";
import YearRail from "./YearRail";
import YearSection from "./YearSection";
import GalleryLightbox from "./GalleryLightbox";
import HistorySkeleton from "./HistorySkeleton";
import HistoryEmpty from "./HistoryEmpty";
import BackToTop from "./BackToTop";
import { groupByYear } from "./utils";

import "./index.css";

export function Component() {
  const [milestones, setMilestones] = useState(null);
  const [error, setError] = useState(false);
  const [searchParams, setSearchParams] = useSearchParams();
  const [activeYear, setActiveYear] = useState(null);
  const [galleryFor, setGalleryFor] = useState(null);

  const category = searchParams.get("categoria");

  useEffect(() => {
    let cancelled = false;
    service
      .getHistory()
      .then((data) => {
        if (!cancelled) setMilestones(data);
      })
      .catch(() => {
        if (!cancelled) setError(true);
      });
    return () => {
      cancelled = true;
    };
  }, []);

  const filtered = useMemo(() => {
    if (!milestones) return [];
    return category
      ? milestones.filter((m) => m.category?.slug === category)
      : milestones;
  }, [milestones, category]);

  const groups = useMemo(() => groupByYear(filtered), [filtered]);
  const featured = useMemo(
    () => (category ? [] : filtered.filter((m) => m.featured)),
    [filtered, category]
  );

  function setCategory(next) {
    setSearchParams(next ? { categoria: next } : {});
  }

  if (error) {
    return <HistoryEmpty variant="error" />;
  }

  if (!milestones) {
    return <HistorySkeleton />;
  }

  return (
    <div className="history-page">
      <HistoryHero milestones={milestones} />

      <CategoryFilter
        milestones={milestones}
        active={category}
        onChange={setCategory}
      />
      <MobileFilterBar
        milestones={milestones}
        activeCategory={category}
        onCategoryChange={setCategory}
        years={groups.map((g) => g.year)}
      />

      {milestones.length === 0 ? (
        <HistoryEmpty variant="empty" />
      ) : (
        <div className="history-layout">
          <YearRail years={groups.map((g) => g.year)} activeYear={activeYear} />

          <div className="history-timeline">
            {groups.map(({ year, items }) => (
              <YearSection
                key={year}
                year={year}
                milestones={items}
                featuredIds={new Set(featured.map((m) => m.id))}
                onYearVisible={setActiveYear}
                onOpenGallery={setGalleryFor}
              />
            ))}
          </div>
        </div>
      )}

      <GalleryLightbox
        milestone={galleryFor}
        onClose={() => setGalleryFor(null)}
      />
      <BackToTop />
    </div>
  );
}

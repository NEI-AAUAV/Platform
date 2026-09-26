import React, { useCallback, useEffect, useMemo, useState } from "react";
import { useSearchParams } from "react-router-dom";

import service from "services/NEIService";

import HistoryHero from "./HistoryHero";
import CategoryFilter from "./CategoryFilter";
import MobileFilterBar from "./MobileFilterBar";
import MandateRail from "./MandateRail";
import MandateSection from "./MandateSection";
import GalleryLightbox from "./GalleryLightbox";
import HistorySkeleton from "./HistorySkeleton";
import HistoryEmpty from "./HistoryEmpty";
import BackToTop from "./BackToTop";
import { groupByMandate } from "./utils";

import "./index.css";

/** URL state: `categoria` (filter), `marco` (open gallery), `foto`
 * (1-based photo in that gallery) — so a filtered view or a single photo
 * can be shared as a link. */
export function Component() {
  const [milestones, setMilestones] = useState(null);
  const [error, setError] = useState(false);
  const [attempt, setAttempt] = useState(0);
  const [searchParams, setSearchParams] = useSearchParams();
  const [activeMandate, setActiveMandate] = useState(null);

  const category = searchParams.get("categoria");
  const galleryId = Number(searchParams.get("marco")) || null;
  const initialPhoto = Math.max(0, (Number(searchParams.get("foto")) || 1) - 1);

  useEffect(() => {
    let cancelled = false;
    setError(false);
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
  }, [attempt]);

  const filtered = useMemo(() => {
    if (!milestones) return [];
    return category
      ? milestones.filter((m) => m.category?.slug === category)
      : milestones;
  }, [milestones, category]);

  const groups = useMemo(() => groupByMandate(filtered), [filtered]);
  const mandates = useMemo(() => groups.map((g) => g.mandate), [groups]);
  const featuredIds = useMemo(
    () => new Set(category ? [] : filtered.filter((m) => m.featured).map((m) => m.id)),
    [filtered, category]
  );
  const galleryFor = useMemo(
    () => milestones?.find((m) => m.id === galleryId) ?? null,
    [milestones, galleryId]
  );

  const updateParams = useCallback(
    (changes, options) => {
      setSearchParams((previous) => {
        const next = new URLSearchParams(previous);
        for (const [key, value] of Object.entries(changes)) {
          if (value == null) next.delete(key);
          else next.set(key, String(value));
        }
        return next;
      }, options);
    },
    [setSearchParams]
  );

  const openGallery = useCallback(
    (milestone) => updateParams({ marco: milestone.id, foto: null }),
    [updateParams]
  );

  if (error) {
    return (
      <HistoryEmpty
        variant="error"
        onRetry={() => {
          setMilestones(null);
          setAttempt((n) => n + 1);
        }}
      />
    );
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
        onChange={(next) => updateParams({ categoria: next })}
      />
      <MobileFilterBar
        milestones={milestones}
        activeCategory={category}
        onCategoryChange={(next) => updateParams({ categoria: next })}
        mandates={mandates}
      />

      {milestones.length === 0 ? (
        <HistoryEmpty variant="empty" />
      ) : (
        <div className="history-layout">
          <MandateRail mandates={mandates} activeMandate={activeMandate} />

          <div className="history-timeline">
            {groups.map(({ mandate, items }) => (
              <MandateSection
                key={mandate}
                mandate={mandate}
                milestones={items}
                featuredIds={featuredIds}
                onMandateVisible={setActiveMandate}
                onOpenGallery={openGallery}
              />
            ))}
          </div>
        </div>
      )}

      <GalleryLightbox
        milestone={galleryFor}
        initialIndex={initialPhoto}
        onIndexChange={(i) => updateParams({ foto: i > 0 ? i + 1 : null }, { replace: true })}
        onClose={() => updateParams({ marco: null, foto: null }, { replace: true })}
      />
      <BackToTop />
    </div>
  );
}

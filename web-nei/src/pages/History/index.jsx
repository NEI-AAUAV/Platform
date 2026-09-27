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
import {
  groupByMandate,
  hasGallery,
  isCategorySlug,
  parsePhotoParam,
  usedCategories,
} from "./utils";

import "./index.css";

/** Params that can't mean anything — a malformed category slug, a gallery
 * that doesn't exist (or has no photos), a photo number that isn't one —
 * mapped to their removal, so the URL never claims a state the page isn't
 * showing. A well-formed slug with no milestones is kept: the page explains
 * the empty result instead. */
function staleParams(searchParams, milestones) {
  const stale = {};
  const category = searchParams.get("categoria");
  if (category !== null && !isCategorySlug(category)) stale.categoria = null;

  const marco = searchParams.get("marco");
  const gallery = milestones.find((m) => String(m.id) === marco);
  if (marco !== null && !(gallery && hasGallery(gallery))) stale.marco = null;

  const foto = searchParams.get("foto");
  const noGallery = marco === null || "marco" in stale;
  if (foto !== null && (noGallery || parsePhotoParam(foto) === null)) stale.foto = null;
  return stale;
}

/** URL state: `categoria` (filter), `marco` (open gallery), `foto`
 * (1-based photo in that gallery) — so a filtered view or a single photo
 * can be shared as a link. */
export function Component() {
  const [milestones, setMilestones] = useState(null);
  const [error, setError] = useState(false);
  const [attempt, setAttempt] = useState(0);
  const [searchParams, setSearchParams] = useSearchParams();
  const [activeMandate, setActiveMandate] = useState(null);

  const rawCategory = searchParams.get("categoria");
  const category = rawCategory && isCategorySlug(rawCategory) ? rawCategory : null;
  const galleryId = searchParams.get("marco");
  const initialPhoto = parsePhotoParam(searchParams.get("foto"));

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

  useEffect(() => {
    if (!milestones) return;
    const stale = staleParams(searchParams, milestones);
    if (Object.keys(stale).length > 0) updateParams(stale, { replace: true });
  }, [milestones, searchParams, updateParams]);

  const filtered = useMemo(() => {
    if (!milestones) return [];
    return category
      ? milestones.filter((m) => m.category?.slug === category)
      : milestones;
  }, [milestones, category]);

  const categoryLabel = useMemo(
    () =>
      milestones &&
      category &&
      usedCategories(milestones).find((c) => c.slug === category)?.label,
    [milestones, category]
  );

  const groups = useMemo(() => groupByMandate(filtered), [filtered]);
  const mandates = useMemo(() => groups.map((g) => g.mandate), [groups]);
  const featuredIds = useMemo(
    () => new Set(category ? [] : filtered.filter((m) => m.featured).map((m) => m.id)),
    [filtered, category]
  );
  const galleryFor = useMemo(() => {
    const milestone = milestones?.find((m) => String(m.id) === galleryId);
    return milestone && hasGallery(milestone) ? milestone : null;
  }, [milestones, galleryId]);

  const openGallery = useCallback(
    (milestone) => updateParams({ marco: milestone.id, foto: null }),
    [updateParams]
  );
  const setCategory = useCallback(
    (next) => updateParams({ categoria: next }),
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

  let timeline;
  if (milestones.length === 0) {
    timeline = <HistoryEmpty variant="empty" />;
  } else if (groups.length === 0) {
    timeline = (
      <HistoryEmpty
        variant="filtered"
        categoryLabel={categoryLabel}
        onReset={() => setCategory(null)}
      />
    );
  } else {
    timeline = (
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
    );
  }

  return (
    <div className="history-page">
      <HistoryHero milestones={milestones} />

      <CategoryFilter milestones={milestones} active={category} onChange={setCategory} />
      <MobileFilterBar
        milestones={milestones}
        activeCategory={category}
        onCategoryChange={setCategory}
        mandates={mandates}
      />

      {timeline}

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

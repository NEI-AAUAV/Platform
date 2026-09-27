/** Categories come from the CMS (`history_category`, managed in Directus —
 * see api-nei/app/models/history.py), not a hardcoded list: each milestone
 * already carries its own `{slug, label, color, weight}`. This dedupes
 * what's present across the loaded milestones, in the editors' order
 * (`weight`, set as "Ordem" in Directus), then by label. */
export function usedCategories(milestones) {
  const bySlug = new Map();
  for (const milestone of milestones) {
    if (milestone.category) bySlug.set(milestone.category.slug, milestone.category);
  }
  return [...bySlug.values()].sort(
    (a, b) =>
      (a.weight ?? 0) - (b.weight ?? 0) || a.label.localeCompare(b.label, "pt-PT")
  );
}

/** The NEI academic year runs September→August. A milestone dated before
 * September belongs to the year that started the previous calendar year. */
export function academicYear(isoDate) {
  const date = new Date(isoDate);
  const year = date.getUTCFullYear();
  const month = date.getUTCMonth(); // 0-indexed; 8 = September
  const startYear = month >= 8 ? year : year - 1;
  const endYear = String((startYear + 1) % 100).padStart(2, "0");
  return `${startYear}/${endYear}`;
}

export function mandateLabel(milestone) {
  return milestone.mandate || academicYear(milestone.moment);
}

function mandateStartYear(mandate) {
  return Number.parseInt(mandate, 10) || 0;
}

/** Groups milestones by mandate (the editorial `mandate`, else derived from
 * the date) — the unit the NEI thinks in — newest mandate first, keeping
 * the caller's order within each mandate. */
export function groupByMandate(milestones) {
  const groups = new Map();
  for (const milestone of milestones) {
    const mandate = mandateLabel(milestone);
    if (!groups.has(mandate)) groups.set(mandate, []);
    groups.get(mandate).push(milestone);
  }
  return [...groups.entries()]
    .sort(([a], [b]) => mandateStartYear(b) - mandateStartYear(a))
    .map(([mandate, items]) => ({ mandate, items }));
}

export function mandateAnchorId(mandate) {
  return `history-mandato-${mandate.replace("/", "-")}`;
}

export function prefersReducedMotion() {
  return window.matchMedia?.("(prefers-reduced-motion: reduce)").matches ?? false;
}

/** `scrollTo`/`scrollIntoView` behaviour honouring the OS "reduce motion"
 * setting: a long smooth scroll through the whole timeline is exactly the
 * kind of motion that setting asks to skip. */
export function scrollBehavior() {
  return prefersReducedMotion() ? "auto" : "smooth";
}

export function scrollToMandate(mandate) {
  document
    .getElementById(mandateAnchorId(mandate))
    ?.scrollIntoView({ behavior: scrollBehavior(), block: "start" });
}

export function formatMilestoneDate(isoDate) {
  return new Date(isoDate).toLocaleDateString("pt-PT", {
    day: "numeric",
    month: "long",
    year: "numeric",
    timeZone: "UTC",
  });
}

/** Number of gallery photos, or null when unknown: a linked Drive folder is
 * only listed when the gallery opens, so the timeline can't count it. */
export function galleryCount(milestone) {
  return milestone.has_drive_gallery ? null : milestone.gallery_count ?? 0;
}

export function hasGallery(milestone) {
  const count = galleryCount(milestone);
  return count === null || count > 0;
}

export function milestoneCover(milestone) {
  return milestone.cover || milestone.image || null;
}

/** Same rule the database enforces on `history_category.slug`: anything
 * else in `?categoria=` can't name a category and is dropped from the URL. */
export function isCategorySlug(value) {
  return /^[a-z0-9-]+$/.test(value);
}

// Category colours are free CMS input rendered into inline styles. Only
// plain colour syntaxes get through; anything else falls back to the theme.
const CSS_COLOR_RE =
  /^(#[0-9a-f]{3,4}|#[0-9a-f]{6}|#[0-9a-f]{8}|(rgb|rgba|hsl|hsla)\([\d\s.,%/+-]+\))$/i;

export function safeCssColor(value) {
  const color = value?.trim();
  return color && CSS_COLOR_RE.test(color) ? color : null;
}

export function categoryStyle(category) {
  const color = safeCssColor(category?.color);
  return color ? { "--chip-color": color } : undefined;
}

/** Parses `?foto=` (1-based); null when absent or not a positive integer. */
export function parsePhotoParam(value) {
  if (value == null) return null;
  return /^[1-9]\d*$/.test(value) ? Number(value) - 1 : null;
}

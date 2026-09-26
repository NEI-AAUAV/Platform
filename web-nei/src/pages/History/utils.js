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

export function scrollToMandate(mandate) {
  document
    .getElementById(mandateAnchorId(mandate))
    ?.scrollIntoView({ behavior: "smooth", block: "start" });
}

export function formatMilestoneDate(isoDate) {
  return new Date(isoDate).toLocaleDateString("pt-PT", {
    day: "numeric",
    month: "long",
    year: "numeric",
    timeZone: "UTC",
  });
}

/** Number of gallery photos, or null when unknown (the API couldn't reach
 * the milestone's Drive folder in time — the gallery endpoint retries). */
export function galleryCount(milestone) {
  if (milestone.gallery_count != null) return milestone.gallery_count;
  return milestone.has_drive_gallery ? null : milestone.media.length;
}

export function hasGallery(milestone) {
  const count = galleryCount(milestone);
  return count === null || count > 0;
}

export function milestoneCover(milestone) {
  return milestone.cover ?? (milestone.image || milestone.media[0]?.thumb || null);
}

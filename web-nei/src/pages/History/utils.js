/** Categories come from the CMS (`history_category`, managed in Directus —
 * see api-nei/app/models/history.py), not a hardcoded list: each milestone
 * already carries its own `{slug, label, color}`. This just dedupes what's
 * present across the loaded milestones, sorted by label so the filter row
 * doesn't reorder itself as new milestones load. */
export function usedCategories(milestones) {
  const bySlug = new Map();
  for (const milestone of milestones) {
    if (milestone.category) bySlug.set(milestone.category.slug, milestone.category);
  }
  return [...bySlug.values()].sort((a, b) => a.label.localeCompare(b.label, "pt-PT"));
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

/** Groups milestones by calendar year (for the timeline's year sections),
 * preserving the caller's sort order within each year. */
export function groupByYear(milestones) {
  const groups = new Map();
  for (const milestone of milestones) {
    const year = new Date(milestone.moment).getUTCFullYear();
    if (!groups.has(year)) groups.set(year, []);
    groups.get(year).push(milestone);
  }
  return [...groups.entries()]
    .sort(([a], [b]) => b - a)
    .map(([year, items]) => ({ year, items }));
}

export function formatMilestoneDate(isoDate) {
  return new Date(isoDate).toLocaleDateString("pt-PT", {
    day: "numeric",
    month: "long",
    year: "numeric",
    timeZone: "UTC",
  });
}

export function mandateLabel(milestone) {
  return milestone.mandate || academicYear(milestone.moment);
}

export function scrollToYear(year) {
  document
    .getElementById(`history-year-${year}`)
    ?.scrollIntoView({ behavior: "smooth", block: "start" });
}

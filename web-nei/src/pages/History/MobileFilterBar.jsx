import React, { useMemo } from "react";

import { usedCategories as deriveUsedCategories, scrollToYear } from "./utils";

/** Mobile/tablet-only (<992px, hidden via CSS above that) replacement for
 * the desktop category-chip row + sticky year rail: two native selects
 * collapse both filters into one sticky toolbar instead of stacking two
 * differently-shaped scroll widgets before any content. */
export default function MobileFilterBar({
  milestones,
  activeCategory,
  onCategoryChange,
  years,
}) {
  const categories = useMemo(() => deriveUsedCategories(milestones), [milestones]);

  if (categories.length === 0 && years.length === 0) return null;

  return (
    <div className="history-mobile-nav" role="group" aria-label="Filtrar e navegar">
      {categories.length > 0 && (
        <label className="history-mobile-nav__field">
          <span className="sr-only">Filtrar por categoria</span>
          <select
            value={activeCategory || ""}
            onChange={(e) => onCategoryChange(e.target.value || null)}
          >
            <option value="">Todas as categorias</option>
            {categories.map((category) => (
              <option key={category.slug} value={category.slug}>
                {category.label}
              </option>
            ))}
          </select>
        </label>
      )}
      {years.length > 0 && (
        <label className="history-mobile-nav__field">
          <span className="sr-only">Saltar para ano</span>
          <select
            defaultValue=""
            onChange={(e) => {
              if (e.target.value) scrollToYear(e.target.value);
              e.target.value = "";
            }}
          >
            <option value="" disabled>
              Saltar para ano
            </option>
            {years.map((year) => (
              <option key={year} value={year}>
                {year}
              </option>
            ))}
          </select>
        </label>
      )}
    </div>
  );
}

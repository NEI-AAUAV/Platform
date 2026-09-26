import React, { useMemo } from "react";

import { usedCategories as deriveUsedCategories, scrollToMandate } from "./utils";

/** Mobile/tablet-only (<992px, hidden via CSS above that) replacement for
 * the desktop category-chip row + sticky mandate rail: two native selects
 * collapse both filters into one sticky toolbar instead of stacking two
 * differently-shaped scroll widgets before any content. */
export default function MobileFilterBar({
  milestones,
  activeCategory,
  onCategoryChange,
  mandates,
}) {
  const categories = useMemo(() => deriveUsedCategories(milestones), [milestones]);

  if (categories.length === 0 && mandates.length === 0) return null;

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
      {mandates.length > 0 && (
        <label className="history-mobile-nav__field">
          <span className="sr-only">Saltar para mandato</span>
          <select
            defaultValue=""
            onChange={(e) => {
              if (e.target.value) scrollToMandate(e.target.value);
              e.target.value = "";
            }}
          >
            <option value="" disabled>
              Mandato…
            </option>
            {mandates.map((mandate) => (
              <option key={mandate} value={mandate}>
                {mandate}
              </option>
            ))}
          </select>
        </label>
      )}
    </div>
  );
}

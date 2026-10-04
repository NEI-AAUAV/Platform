import React, { useMemo } from "react";
import classNames from "classnames";

import { categoryStyle, usedCategories as deriveUsedCategories } from "./utils";

export default function CategoryFilter({ milestones, active, onChange }) {
  const categories = useMemo(() => deriveUsedCategories(milestones), [milestones]);

  if (categories.length === 0) return null;

  return (
    <fieldset className="history-filters" aria-label="Filtrar por categoria">
      <button
        type="button"
        className={classNames("history-filter-chip", { "is-active": !active })}
        aria-pressed={!active}
        onClick={() => onChange(null)}
      >
        Todos
      </button>
      {categories.map((category) => (
        <button
          key={category.slug}
          type="button"
          className={classNames("history-filter-chip", {
            "is-active": active === category.slug,
          })}
          style={categoryStyle(category)}
          aria-pressed={active === category.slug}
          onClick={() => onChange(active === category.slug ? null : category.slug)}
        >
          {category.label}
        </button>
      ))}
    </fieldset>
  );
}

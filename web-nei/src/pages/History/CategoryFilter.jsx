import React, { useMemo } from "react";
import classNames from "classnames";

import { usedCategories as deriveUsedCategories } from "./utils";

export default function CategoryFilter({ milestones, active, onChange }) {
  const categories = useMemo(() => deriveUsedCategories(milestones), [milestones]);

  if (categories.length === 0) return null;

  return (
    <div className="history-filters" role="group" aria-label="Filtrar por categoria">
      <button
        type="button"
        className={classNames("history-filter-chip", { "is-active": !active })}
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
          style={{ "--chip-color": category.color || "hsl(var(--muted-foreground))" }}
          onClick={() => onChange(active === category.slug ? null : category.slug)}
        >
          {category.label}
        </button>
      ))}
    </div>
  );
}

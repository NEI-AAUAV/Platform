import React from "react";
import classNames from "classnames";

import { scrollToYear } from "./utils";

export default function YearRail({ years, activeYear }) {
  if (years.length === 0) return null;

  return (
    <nav className="history-year-rail" aria-label="Navegar por ano">
      <ul>
        {years.map((year) => (
          <li key={year}>
            <button
              type="button"
              className={classNames("history-year-rail__item", {
                "is-active": year === activeYear,
              })}
              onClick={() => scrollToYear(year)}
            >
              {year}
            </button>
          </li>
        ))}
      </ul>
    </nav>
  );
}

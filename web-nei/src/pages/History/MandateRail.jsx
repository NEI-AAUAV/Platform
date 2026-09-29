import React from "react";
import classNames from "classnames";

import { scrollToMandate } from "./utils";

export default function MandateRail({ mandates, activeMandate }) {
  if (mandates.length === 0) return null;

  return (
    <nav className="history-year-rail" aria-label="Navegar por mandato">
      <ul>
        {mandates.map((mandate) => (
          <li key={mandate}>
            <button
              type="button"
              className={classNames("history-year-rail__item", {
                "is-active": mandate === activeMandate,
              })}
              aria-current={mandate === activeMandate ? "true" : undefined}
              onClick={() => scrollToMandate(mandate)}
            >
              {mandate}
            </button>
          </li>
        ))}
      </ul>
    </nav>
  );
}

import React, { useMemo, useState } from "react";

import NEICalendar from "./NEICalendar";

import CheckboxDropdown from "components/CheckboxDropdown";
import {
  CalendarViewMonthIcon,
  FilterIcon,
  ViewAgendaIcon,
} from "assets/icons/google";
import { TabsButton } from "components";

import data from "./data";
import config from "config";

const Views = {
  CALENDAR: 0,
  AGENDA: 1,
};

export function Component() {
  const [categories, setCategories] = useState(
    // NOTE: change active state according to user information
    Object.entries(data.categories).map(([k, v]) => ({
      ...v,
      key: k,
      checked: true,
    }))
  );
  const [view, setView] = useState(Views.CALENDAR);

  // Applied at render time, so the filter persists across month changes
  const hiddenCategories = useMemo(
    () => new Set(categories.filter((c) => !c.checked).map((c) => c.key)),
    [categories]
  );

  return (
    <div>
      <h2 className="text-center">Calendário</h2>

      <div className="flex justify-between">
        <TabsButton
          tabs={[
            <>
              <CalendarViewMonthIcon /> Mês
            </>,
            // Agenda view is not implemented yet
            ...(config.PRODUCTION
              ? []
              : [
                  <>
                    <ViewAgendaIcon /> Agenda
                  </>,
                ]),
          ]}
          selected={view}
          setSelected={setView}
        />

        <CheckboxDropdown
          className="btn-sm m-1"
          values={categories}
          onChange={setCategories}
        >
          Filter <FilterIcon />
        </CheckboxDropdown>
      </div>

      {view === Views.CALENDAR && (
        <NEICalendar hiddenCategories={hiddenCategories} />
      )}
      {view === Views.AGENDA && "Meter uma linda agenda aqui"}
    </div>
  );
}

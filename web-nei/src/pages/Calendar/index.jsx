import React, { useEffect, useState } from "react";

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
    // TODO: change active state according to user information
    Object.entries(data.categories).map(([k, v]) => ({
      ...v,
      key: k,
      checked: true,
    }))
  );
  const [view, setView] = useState(Views.CALENDAR);

  useEffect(() => {
    for (const c of categories) {
      const elements = document.querySelectorAll(`[datatype="${c.key}"]`);
      if (c.checked) {
        for (const e of elements) {
          e.classList.remove("opacity-20");
          e.classList.remove("pointer-events-none");
        }
      } else {
        for (const e of elements) {
          e.classList.add("opacity-20");
          e.classList.add("pointer-events-none");
        }
      }
    }
  }, [categories]);

  return (
    <div>
      <h2 className="text-center">
        Calendário
      </h2>

      <div className="flex justify-between">
        <TabsButton
          tabs={[
            <>
              <CalendarViewMonthIcon /> Mês
            </>
          ] + !config.PRODUCTION ? [(
            <>
              <ViewAgendaIcon /> Agenda
            </>
          )] : []}
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

      {view === Views.CALENDAR && <NEICalendar />}
      {view === Views.AGENDA && "Meter uma linda agenda aqui"}
    </div>
  );
}

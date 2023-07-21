import React, { useState } from "react";

import Typist from "react-typist";
import NEICalendar from "./NEICalendar";

import CheckboxDropdown from "components/CheckboxDropdown";
import {
  CalendarViewMonthIcon,
  FilterIcon,
  ViewAgendaIcon,
} from "assets/icons/google";
import { TabsButton } from "components";

import data from "./data";

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

  return (
    <div>
      <h2 className="text-center">
        <Typist>Calendário</Typist>
      </h2>

      <div className="flex justify-between">
        <TabsButton
          tabs={[
            <>
              <CalendarViewMonthIcon /> Mês
            </>,
            <>
              <ViewAgendaIcon /> Agenda
            </>,
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

      {view === Views.CALENDAR && <NEICalendar />}
      {view === Views.AGENDA && "Meter uma linda agenda aqui"}
    </div>
  );
}

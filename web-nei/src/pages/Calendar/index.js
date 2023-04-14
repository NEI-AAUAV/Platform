import React, { useState } from "react";
import classNames from "classnames";

import Typist from "react-typist";
import NEICalendar from "./NEICalendar";

import CheckboxDropdown from "components/CheckboxDropdown";
import { CalendarViewMonthIcon, FilterIcon, ViewAgendaIcon } from "assets/icons/google";

import data from "./data";

const Views = {
  CALENDAR: 1,
  AGENDA: 2,
};

const Calendar = () => {
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
        <div className="flex w-fit items-center space-x-1 rounded-full bg-base-200 px-2 py-1">
          <button
            className={classNames(
              "btn-sm btn gap-2 border-none bg-accent py-1",
              view === Views.CALENDAR
                ? "no-animation shadow hover:bg-accent"
                : "bg-transparent hover:bg-base-300 hover:opacity-75"
            )}
            onClick={() => setView(Views.CALENDAR)}
          >
            <CalendarViewMonthIcon /> Mês
          </button>
          <button
            className={classNames(
              "btn-sm btn gap-2 border-none bg-accent py-1",
              view === Views.AGENDA
                ? "no-animation shadow hover:bg-accent"
                : "bg-transparent hover:bg-base-300 hover:opacity-75"
            )}
            onClick={() => setView(Views.AGENDA)}
          >
            <ViewAgendaIcon /> Agenda
          </button>
        </div>

        <CheckboxDropdown className="btn-sm m-1" values={categories} onChange={setCategories}>
          Filter <FilterIcon />
        </CheckboxDropdown>
      </div>

      <div>
        <NEICalendar />
      </div>
    </div>
  );
};

export default Calendar;

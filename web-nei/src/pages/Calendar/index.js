import React, { useState } from "react";
import classNames from "classnames";

import Typist from "react-typist";
import Calendar2 from "components/Calendar2";
import Calendar1 from "components/Calendar1";
import CheckboxFilter from "components/CheckboxFilter";
import { CalendarViewMonthIcon, ViewAgendaIcon } from "assets/icons/google";

import data from "./data";

const VIEWS = {
  CALENDAR: 1,
  AGENDA: 2,
};

const Calendar = () => {
  const [categories, setCategories] = useState(
    // TODO: change active state according to user information
    data.categories.map((c) => ({ ...c, checked: true }))
  );
  const [view, setView] = useState(VIEWS.CALENDAR);

  return (
    <div>
      <h2 className="text-center">
        <Typist>Calendário</Typist>
      </h2>

      <div className="flex justify-between">
        <div className="flex w-fit items-center space-x-1 rounded-full bg-base-200 py-1 px-2">
          <button
            className={classNames(
              "btn-sm btn gap-2 border-none bg-accent py-1",
              view === VIEWS.CALENDAR
                ? "no-animation shadow hover:bg-accent"
                : "bg-transparent hover:bg-base-300 hover:opacity-75"
            )}
            onClick={() => setView(VIEWS.CALENDAR)}
          >
            <CalendarViewMonthIcon /> Mês
          </button>
          <button
            className={classNames(
              "btn-sm btn gap-2 border-none bg-accent py-1",
              view === VIEWS.AGENDA
                ? "no-animation shadow hover:bg-accent"
                : "bg-transparent hover:bg-base-300 hover:opacity-75"
            )}
            onClick={() => setView(VIEWS.AGENDA)}
          >
            <ViewAgendaIcon /> Agenda
          </button>
        </div>

        <CheckboxFilter values={categories} onChange={setCategories} />
      </div>

      {/* <NEICalendar
                selection={selection}
                setInitialCategories={(fs) => {
                    setFilters(fs);
                    setSelection(fs.map(f => f['filter']));
                }}

                style={{
                    animationDelay: animationBase + animationIncrement * 2 + "s",
                }}
            /> */}
      <div className="slideUpFade">
        <Calendar1 />
      </div>
    </div>
  );
};

export default Calendar;

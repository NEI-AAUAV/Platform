/** @jsxRuntime classic */
/** @jsx jsx */
import { css, jsx } from "@emotion/react";
import React, { useEffect, useState } from "react";
import classname from "classname";

import NEICalendar from "./NEICalendar";
import Filters from "../../components/Filters";
import Typist from "react-typist";
import Calendar2 from "components/Calendar2";
import Calendar1 from "components/Calendar1";
import {
  FilterIcon,
  CalendarViewMonthIcon,
  ViewAgendaIcon,
} from "assets/icons/google";

const CATEGORIES = [
  { key: "1A", name: "1º Ano", color: "187 99% 45%" },
  { key: "2A", name: "2º Ano", color: "187 99% 38%" },
  { key: "3A", name: "3º Ano", color: "187 99% 30%" },
  { key: "MEI", name: "MEI", color: "187 98% 20%" },
  { key: "NEI", name: "NEI", color: "131 72% 28%" },
  { key: "Taça UA", name: "Taça UA", color: "359 85% 45%" },
  {
    keys: [
      "FERIADO",
      "Época de",
      "Férias",
      "Último dia",
      "Primeiro dia",
      "Integração",
    ],
    name: "Calendário escolar",
    color: "38 100% 50%",
  },
];

const VIEWS = {
  CALENDAR: 1,
  AGENDA: 2,
};

const Calendar = () => {
  const [categoryFilter, setCategoryFilter] = useState(
    CATEGORIES.reduce((o, { key }) => ({ ...o, [key]: true }), {})
  );
  const [view, setView] = useState(VIEWS.CALENDAR);

  // Animation
  const animationBase = parseFloat(process.env.REACT_APP_ANIMATION_BASE);
  const animationIncrement = parseFloat(
    process.env.REACT_APP_ANIMATION_INCREMENT
  );

  const [filters, setFilters] = useState([]);
  const [selection, setSelection] = useState([]);

  return (
    <div>
      <h2 className="text-center">
        <Typist>Calendário</Typist>
      </h2>

      <div className="flex justify-between">
        <div class="flex items-center bg-base-200 rounded-full py-1 px-2 space-x-1 w-fit">
          <button
            className={classname(
              "btn btn-sm bg-accent gap-2 py-1 border-none",
              view === VIEWS.CALENDAR
                ? "shadow no-animation hover:bg-accent"
                : "bg-transparent hover:opacity-75 hover:bg-base-300"
            )}
            onClick={() => setView(VIEWS.CALENDAR)}
          >
            <CalendarViewMonthIcon /> Mês
          </button>
          <button
            className={classname(
              "btn btn-sm bg-accent gap-2 py-1 border-none",
              view === VIEWS.AGENDA
                ? "shadow no-animation hover:bg-accent"
                : "bg-transparent hover:opacity-75 hover:bg-base-300"
            )}
            onClick={() => setView(VIEWS.AGENDA)}
          >
            <ViewAgendaIcon /> Agenda
          </button>
        </div>

        <div className="dropdown dropdown-end">
          <label tabIndex={0} className="btn btn-sm gap-2 m-1">
            Filter
            <FilterIcon />
          </label>
          <ul
            tabIndex={0}
            className="dropdown-content menu p-2 shadow bg-base-200 border border-base-300 rounded-box w-52 font-medium"
          >
            {CATEGORIES.map(({ key, name, color }, index) => (
              <li key={index}>
                <label>
                  <input
                    type="checkbox"
                    checked={categoryFilter[key]}
                    onChange={() =>
                      setCategoryFilter({
                        ...categoryFilter,
                        [key]: !categoryFilter[key],
                      })
                    }
                    className="checkbox checkbox-sm"
                    // Customize DaisyUI colors
                    css={css`
                      --chkbg: ${color};
                      border-color: hsl(${color});
                      &:checked {
                        background-color: hsl(${color});
                      }
                    `}
                  />
                  <span className="label-text px-2">{name}</span>
                </label>
              </li>
            ))}
          </ul>
        </div>
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

/** @jsxRuntime classic */
/** @jsx jsx */
import { css, jsx } from "@emotion/react";
import { useState, useEffect, Fragment, useCallback } from "react";
import classNames from "classnames";

import { useWindowSize } from "utils/hooks";
import { ArrowForwardIcon, ArrowBackIcon } from "assets/icons/google";

import service from "services/GoogleCalendarService";

import data from "./data";
import { categories } from "../data";

import { getWeeklyIntervals } from "./utils";

import { EventDialog } from "components/Dialog";


const Calendar = () => {
  const windowSize = useWindowSize();
  const [month, setMonth] = useState(3);
  const [year, setYear] = useState(2023);

  const [dayEvents, setDayEvents] = useState({});
  const [selEvent, setSelEvent] = useState(null);

  // const [openEventModal, setOpenEventModal] = useState(false);

  useEffect(() => {
    let today = new Date();
    setMonth(today.getMonth());
    setYear(today.getFullYear());
    initDayEvents();
  }, []);

  useEffect(() => {
    initDayEvents();
  }, [month, year]);

  useEffect(() => {
    if (Object.keys(dayEvents).length > 0) {
      fetchEvents();
    }
  }, [dayEvents]);

  function handleMonthChange(month) {
    setTimeout(() => {
    const lapsedYears = Math.floor(month / 12);
    setYear(year + lapsedYears);
    const lapsedMonths = month % 12;
    setMonth(lapsedMonths >= 0 ? lapsedMonths : 12 + lapsedMonths);
    }, 200)
  }

  function isToday(date) {
    const today = new Date();
    return today.toLocaleDateString("en-US") === date;
  }

  // function showEventModal(date) {
  //   // Open the modal
  //   setOpenEventModal(true);
  // }

  // function addEvent() {
  //   // ...
  //   // Close the modal
  //   setOpenEventModal(false);
  // }

  const initDayEvents = useCallback(async () => {
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    const firstMonthDay = new Date(year, month, 1).getDay();
    const lastMonthDay = new Date(year, month + 1, 0).getDay();

    const dayEvents = {};

    for (
      let day = 1 - firstMonthDay;
      day < daysInMonth + 7 - lastMonthDay;
      day++
    ) {
      const date = new Date(year, month, day);
      dayEvents[date.toLocaleDateString("en-US")] = [];
    }
    setDayEvents(dayEvents);
  }, [year, month]);

  const fetchEvents = () => {
    const calendarSince = new Date(Object.keys(dayEvents).at(0)),
      calendarTo = new Date(Object.keys(dayEvents).at(-1));

    const timeMin =
      `${calendarSince.getFullYear()}-` +
      `${calendarSince.getMonth() + 1}-` +
      `${calendarSince.getDate()}T00:00:00+01:00`;
    const timeMax =
      `${calendarTo.getFullYear()}-` +
      `${calendarTo.getMonth() + 1}-` +
      `${calendarTo.getDate()}T00:00:00+01:00`;

    service.getEvents({ timeMin, timeMax }).then(({ data }) => {
      let events = [];
      data.items.forEach((e) => {  
        let start = new Date(e.start.date || e.start.dateTime);
        let end = new Date(e.end.date || e.end.dateTime);
        if (e.end.date) {
          // Google API considers end date as the day after the event at midnight,
          // so one day is substracted
          end.setDate(end.getDate() - 1);
        }
        events = events.concat(
          getWeeklyIntervals(start, end).map(({ weekStart, weekEnd }) => ({
            id: e["id"],
            title: e["summary"],
            allDay: "date" in e["start"],
            category: getCategory(e["summary"]),
            weekStart,
            start,
            end,
            duration:
              Math.ceil(
                (weekEnd.getTime() - weekStart.getTime()) / (1000 * 60 * 60 * 24)
              ) + 1,
          }))
        );
      });

      // Assign events to a day slot in a way that they don't overlap
      // and fit the free slots efficiently
      events.sort((a, b) => a.start - b.start);
      for (const e of events) {
        if (e.weekStart.toLocaleDateString("en-US") in dayEvents) {
          const arr = dayEvents[e.weekStart.toLocaleDateString("en-US")];
          // Find first free slot
          const index = [...arr, undefined].findIndex((e) => e === undefined);
          arr[index] = e;
          for (let i = 1; i < e.duration; i++) {
            const date = new Date(e.weekStart);
            date.setDate(date.getDate() + i);
            // Occupy the next slots adjacent
            dayEvents[date.toLocaleDateString("en-US")][index] = null;
          }
        }
      }
      setDayEvents(dayEvents);
    });
  };

  function getCategory(title) {
    for (const [key, c] of Object.entries(categories)) {
      if (c.prefixes) {
        for (const p of c.prefixes) {
          if (title.startsWith(p)) {
            return { ...c, key };
          }
        }
      }
    }
    // Return NEI category by default
    return categories.NEI;
  }

  return (
    <div>
      <div className="container mx-auto mt-4">
        <div className="overflow-hidden rounded-lg bg-base-200 shadow">
          <div className="flex items-center justify-between px-6 py-2">
            <div>
              <span className="text-lg font-bold text-base-content">
                {data.months[month]}
              </span>
              <span className="ml-1 text-lg font-normal text-base-content">
                {year}
              </span>
            </div>
            <div className="flex gap-2 px-1">
              <button
                type="button"
                className="btn-ghost btn-sm btn-circle btn"
                onClick={() => handleMonthChange(month - 1)}
              >
                <ArrowBackIcon />
              </button>
              <button
                type="button"
                className="btn-ghost btn-sm btn-circle btn"
                onClick={() => handleMonthChange(month + 1)}
              >
                <ArrowForwardIcon />
              </button>
            </div>
          </div>

          <div className="-mx-px -mb-px">
            <div className="grid grid-cols-7">
              {data.weekDays.map((day, index) => (
                <div className="py-2" key={index}>
                  <div className="text-center text-sm font-bold uppercase tracking-wide text-gray-600">
                    {windowSize.width < 768 ? day[0] : day}
                  </div>
                </div>
              ))}
            </div>
            <div className="grid grid-cols-7 border-l border-t border-base-content/10">
              {Object.entries(dayEvents).map(([day, events], index) => (
                <Fragment key={index}>
                  <div className="min-h-[120px] border-b border-r border-base-content/10">
                    <div
                      // onClick={() => showEventModal(day)}
                      className={classNames(
                        "m-2 inline-flex h-6 w-6 cursor-pointer items-center justify-center rounded-full leading-none transition duration-100 ease-in-out",
                        {
                          "bg-secondary text-white": isToday(day),
                          "hover:bg-secondary/50": !isToday(day),
                          "text-base-content/50":
                            new Date(day).getMonth() !== month,
                        }
                      )}
                    >
                      {new Date(day).getDate()}
                    </div>
                    <div className="">
                      {[...events].map((event, index) => {
                        const selected = !!event && event.id === selEvent?.id;
                        return (
                          <Fragment key={index}>
                            <EventDialog
                              event={event}
                              className="w-full"
                              layoutId="event-dialog"
                              onShowChange={(show) =>
                                !show && setSelEvent(null)
                              }
                            >
                              <div
                                className={classNames(
                                  "relative left-0 z-10 mb-2 cursor-pointer rounded font-medium text-white hover:shadow-md",
                                  { invisible: !event },
                                  {
                                    "shadow-md": selected,
                                  }
                                )}
                                style={{
                                  width: `calc(${event?.duration * 100}% + ${
                                    event?.duration - 1
                                  }px - 0.4rem)`,
                                  marginLeft: "0.2rem",
                                  background: `hsl(${
                                    event?.category?.color
                                  } / ${selected ? 1 : 0.7})`,
                                }}
                                onClick={() => setSelEvent(event)}
                              >
                                <p className="h-[24px] overflow-hidden truncate text-clip px-1 text-xs !leading-[24px] sm:text-sm">
                                  {event?.title}
                                </p>
                              </div>
                            </EventDialog>
                          </Fragment>
                        );
                      })}
                    </div>
                    {/* <div
                      style={{ height: "80px" }}
                      className="mt-1 overflow-y-auto"
                    >
                      
                      {events
                        .filter(
                          (e) =>
                            new Date(e.date).toLocaleDateString() ===
                            new Date(year, month, date).toLocaleDateString()
                        )
                        .map((event, index) => (
                          <div
                            key={index}
                            css={css`
                              background-color: hsl(${event.theme});
                            `}
                          >
                            <p className="truncate text-sm font-bold leading-tight">
                              {event.title}
                            </p>
                          </div>
                        ))} 
                    </div>*/}
                  </div>
                </Fragment>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Modal */}
      <div
        style={{ backgroundColor: "rgba(0, 0, 0, 0.8)", display: "none" }}
        className="fixed bottom-0 left-0 right-0 top-0 z-40 h-full w-full"
      >
        {" "}
        {/*x-show.transition.opacity="openEventModal"*/}
        <div className="absolute left-0 right-0 mx-auto mt-24 max-w-xl overflow-hidden p-4">
          <div
            className="absolute right-0 top-0 inline-flex h-10 w-10 cursor-pointer items-center justify-center rounded-full bg-white text-gray-500 shadow hover:text-gray-800"
            // onClick={() => setOpenEventModal(!openEventModal)}
          >
            <svg
              className="h-6 w-6 fill-current"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
            >
              <path d="M16.192 6.344L11.949 10.586 7.707 6.344 6.293 7.758 10.535 12 6.293 16.242 7.707 17.656 11.949 13.414 16.192 17.656 17.606 16.242 13.364 12 17.606 7.758z" />
            </svg>
          </div>

          <div className="block w-full overflow-hidden rounded-lg bg-white p-8 shadow">
            <h2 className="mb-6 border-b pb-2 text-2xl font-bold text-gray-800">
              Add Event Details
            </h2>

            <div className="mb-4">
              <label className="mb-1 block text-sm font-bold tracking-wide text-gray-800">
                Event title
              </label>
              <input
                className="w-full appearance-none rounded-lg border-2 border-gray-200 bg-gray-200 px-4 py-2 leading-tight text-gray-700 focus:border-blue-500 focus:bg-white focus:outline-none"
                type="text"
                // value={event.title}
                // onChange={(e) => setEvent({ ...event, title: e.target.value })}
              />
            </div>

            <div className="mb-4">
              <label className="mb-1 block text-sm font-bold tracking-wide text-gray-800">
                Event date
              </label>
              <input
                className="w-full appearance-none rounded-lg border-2 border-gray-200 bg-gray-200 px-4 py-2 leading-tight text-gray-700 focus:border-blue-500 focus:bg-white focus:outline-none"
                type="text"
                // value={event.date}
                readOnly
              />
            </div>

            <div className="mb-4 inline-block w-64">
              <label className="mb-1 block text-sm font-bold tracking-wide text-gray-800">
                Select a theme
              </label>
              <div className="relative">
                <select
                  // onChange={(e) =>
                  //   setEvent({ ...event, theme: e.target.value })
                  // }
                  // value={event.theme}
                  className="block w-full appearance-none rounded-lg border-2 border-gray-200 bg-gray-200 px-4 py-2 pr-8 leading-tight text-gray-700 hover:border-gray-500 focus:border-blue-500 focus:bg-white focus:outline-none"
                >
                  {[1, 2].map((theme, index) => (
                    <option key={index} value={theme.value}>
                      {theme.label}
                    </option>
                  ))}
                </select>
                <div className="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
                  <svg
                    className="h-4 w-4 fill-current"
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 20 20"
                  >
                    <path d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z" />
                  </svg>
                </div>
              </div>
            </div>

            <div className="mt-8 text-right">
              <button
                type="button"
                className="mr-2 rounded-lg border border-gray-300 bg-white px-4 py-2 font-semibold text-gray-700 shadow-sm hover:bg-gray-100"
                // onClick={() => setOpenEventModal(!openEventModal)}
              >
                Cancel
              </button>
              <button
                type="button"
                className="rounded-lg border border-gray-700 bg-gray-800 px-4 py-2 font-semibold text-white shadow-sm hover:bg-gray-700"
                // onClick={addEvent}
              >
                Save Event
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Calendar;

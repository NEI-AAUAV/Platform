/** @jsxRuntime classic */
/** @jsx jsx */
import { css, jsx } from "@emotion/react";
import { useState, useEffect, Fragment } from "react";
import classNames from "classnames";

import { useWindowSize } from "utils/hooks";
import { ArrowForwardIcon, ArrowBackIcon } from "assets/icons/google";

import service from "services/GoogleCalendarService";

import data from "./data";
import { getWeeklyIntervals } from "./utils";

const selection = ["[1A]", "2A", "[NEI]", "3A"];

const Calendar = () => {
  const windowSize = useWindowSize();
  const [month, setMonth] = useState("");
  const [year, setYear] = useState("");
  const [numOfDays, setNumOfDays] = useState([]);
  const [blankDays, setBlankDays] = useState([]);

  const [calendarSince, setCalendarSince] = useState(null);
  const [calendarTo, setCalendarTo] = useState(null);

  const [events, setEvents] = useState([]);

  const [event, setEvent] = useState({ title: "", date: "", theme: "blue" });

  const themes = [
    { value: "blue", label: "Blue Theme" },
    { value: "red", label: "Red Theme" },
    { value: "yellow", label: "Yellow Theme" },
    { value: "green", label: "Green Theme" },
    { value: "purple", label: "Purple Theme" },
  ];

  const [openEventModal, setOpenEventModal] = useState(false);

  // On render, initialize calendarSince and calendarTo based on current moment
  // Also initialize categories
  useEffect(() => {
    initDate();
    getNumOfDays();
    timespanChanged(new Date());
  }, []);

  useEffect(() => {
    if (calendarSince === null || calendarTo === null) {
      return;
    }
    const timeMin =
      `${calendarSince.getFullYear()}-` +
      `${calendarSince.getMonth() + 1}-` +
      `${calendarSince.getDate()}T00:00:00+01:00`;
    const timeMax =
      `${calendarTo.getFullYear()}-` +
      `${calendarTo.getMonth() + 1}-` +
      `${calendarTo.getDate()}T00:00:00+01:00`;

    service.getEvents({ timeMin, timeMax }).then(({ data }) => {
      let apiEvents = [];
      data.items.forEach((e) => {
        // Check that event matches selection
        let matchAny = true;
        let matchSelected = true;
        // Object.entries(categoriesTypes).forEach(([key, c]) => {
        //     c['filters'].forEach(f => {
        //         if (e['summary'].toLowerCase().indexOf(f.toLowerCase()) >= 0) {
        //             matchAny = true;
        //             matchSelected = selection.indexOf(key) >= 0;
        //         }
        //     });
        // });
        // It must match any filter, if not, is considered NEI event (default) and to be showed NEI must be in selection
        if (
          matchSelected == false &&
          ((matchAny && selection.indexOf("NEI") >= 0) ||
            selection.indexOf("NEI") < 0)
        ) {
          return;
        }
        // If so, compute object to add to events list
        const start =
          "date" in e["start"] ? e["start"]["date"] : e["start"]["dateTime"];
        let end = "date" in e["end"] ? e["end"]["date"] : e["end"]["dateTime"];
        if ("date" in e["end"]) {
          let endDate = new Date(end);
          endDate = endDate.setDate(endDate.getDate() - 1);
          end = endDate;
        }
       
        apiEvents = apiEvents.concat(
          getWeeklyIntervals(new Date(start), new Date(end)).map(
            ({ start, end }) => ({
              id: e["id"],
              title: e["summary"],
              allDay: "date" in e["start"],
              start,
              end,
            })
          )
        );
      });

      apiEvents.sort((a, b) => a.start - b.start);
      console.log(apiEvents)
      for (const i = 1; i < apiEvents.length; i++) {
        apiEvents[i].start.getDate()
      }

      setEvents(apiEvents);
    });
  }, [selection, calendarSince, calendarTo]);

  // On navigate, update next and prev moments and recall API
  function timespanChanged(date) {
    let next = new Date(date);
    let prev = new Date(date);

    if (date.getMonth() == 11) {
      next.setMonth(0);
      next.setYear(date.getFullYear() + 1);
      prev.setMonth(date.getMonth() - 1);
    } else if (date.getMonth() == 0) {
      next.setMonth(date.getMonth() + 1);
      prev.setMonth(11);
      prev.setYear(date.getFullYear() - 1);
    } else {
      next.setMonth(date.getMonth() + 1);
      prev.setMonth(date.getMonth() - 1);
    }

    setCalendarSince(prev);
    setCalendarTo(next);
  }

  function initDate() {
    let today = new Date();
    setMonth(today.getMonth());
    setYear(today.getFullYear());
    // datepickerValue = new Date(year, month, today.getDate()).toDateString();
  }

  function isToday(date) {
    const today = new Date();
    const d = new Date(year, month, date);

    return today.toDateString() === d.toDateString();
  }

  function showEventModal(date) {
    // Open the modal
    setOpenEventModal(true);
    setEvent({
      ...event,
      date: new Date(year, month, date).toDateString(),
    });
  }

  function addEvent() {
    // ...
    // Close the modal
    setOpenEventModal(false);
  }

  function getNumOfDays() {
    let daysInMonth = new Date(year, month + 1, 0).getDate();

    // Find where to start calendar day of week
    let dayOfWeek = new Date(year, month).getDay();
    let blankDaysArray = [];
    for (var i = 1; i <= dayOfWeek; i++) {
      blankDaysArray.push(i);
    }

    let daysArray = [];
    for (var i = 1; i <= daysInMonth; i++) {
      daysArray.push(i);
    }

    setBlankDays(blankDaysArray);
    setNumOfDays(daysArray);
  }

  

  return (
    <div>
      <div className="container mx-auto mt-4">
        <div className="overflow-hidden rounded-lg bg-base-200 shadow">
          <div className="flex items-center justify-between py-2 px-6">
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
                className={classNames("btn-ghost btn-sm btn-circle btn", {
                  "cursor-not-allowed opacity-25": month == 0,
                })}
                disabled={month == 0}
                onClick={() => {
                  setMonth((prevMonth) => prevMonth--);
                  getNumOfDays();
                }}
              >
                <ArrowBackIcon />
              </button>
              <button
                type="button"
                className={classNames("btn-ghost btn-sm btn-circle btn", {
                  "btn-disabled": month == 11,
                })}
                disabled={month == 11}
                onClick={() => {
                  setMonth((prevMonth) => prevMonth++);
                  getNumOfDays();
                }}
              >
                <ArrowForwardIcon />
              </button>
            </div>
          </div>

          <div className="-mx-1 -mb-1">
            <div className="flex flex-wrap">
              {data.weekDays.map((day, index) => (
                <div className="w-1/7 py-2" key={index}>
                  <div className="text-center text-sm font-bold uppercase tracking-wide text-gray-600">
                    {windowSize.width < 768 ? day[0] : day}
                  </div>
                </div>
              ))}
            </div>

            <div className="flex flex-wrap border-t border-l">
              {blankDays.map((blankday) => {
                <div
                  key={blankday}
                  style={{ height: "120px" }}
                  className="border-r border-b px-2 pt-2 text-center"
                ></div>;
              })}
              {numOfDays.map((date, dateIndex) => (
                <Fragment key={dateIndex}>
                  <div
                    style={{ height: "120px" }}
                    className="relative w-1/7 border-r border-b pt-2 text-center md:px-2 md:text-left"
                  >
                    {console.log(date)}
                    <div className="absolute top-0 left-0 h-2 w-[50%] bg-red-200"></div>

                    <div
                      onClick={() => showEventModal(date)}
                      className={classNames(
                        "inline-flex h-6 w-6 cursor-pointer items-center justify-center rounded-full leading-none transition duration-100 ease-in-out",
                        {
                          "bg-blue-500 text-white": isToday(date),
                          "hover:bg-blue-200": !isToday(date),
                        }
                      )}
                    >
                      {date}
                    </div>
                    <div
                      style={{ height: "80px" }}
                      className="mt-1 overflow-y-auto"
                    >
                      {events
                        .filter(
                          (e) =>
                            new Date(e.date).toDateString() ===
                            new Date(year, month, date).toDateString()
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
                    </div>
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
        className="fixed top-0 right-0 left-0 bottom-0 z-40 h-full w-full"
      >
        {" "}
        {/*x-show.transition.opacity="openEventModal"*/}
        <div className="absolute relative left-0 right-0 mx-auto mt-24 max-w-xl overflow-hidden p-4">
          <div
            className="absolute right-0 top-0 inline-flex h-10 w-10 cursor-pointer items-center justify-center rounded-full bg-white text-gray-500 shadow hover:text-gray-800"
            onClick={() => setOpenEventModal(!openEventModal)}
          >
            <svg
              className="h-6 w-6 fill-current"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
            >
              <path d="M16.192 6.344L11.949 10.586 7.707 6.344 6.293 7.758 10.535 12 6.293 16.242 7.707 17.656 11.949 13.414 16.192 17.656 17.606 16.242 13.364 12 17.606 7.758z" />
            </svg>
          </div>

          <div className="block w-full w-full overflow-hidden rounded-lg bg-white p-8 shadow">
            <h2 className="mb-6 border-b pb-2 text-2xl font-bold text-gray-800">
              Add Event Details
            </h2>

            <div className="mb-4">
              <label className="mb-1 block text-sm font-bold tracking-wide text-gray-800">
                Event title
              </label>
              <input
                className="w-full appearance-none rounded-lg border-2 border-gray-200 bg-gray-200 py-2 px-4 leading-tight text-gray-700 focus:border-blue-500 focus:bg-white focus:outline-none"
                type="text"
                value={event.title}
                onChange={(e) => setEvent({ ...event, title: e.target.value })}
              />
            </div>

            <div className="mb-4">
              <label className="mb-1 block text-sm font-bold tracking-wide text-gray-800">
                Event date
              </label>
              <input
                className="w-full appearance-none rounded-lg border-2 border-gray-200 bg-gray-200 py-2 px-4 leading-tight text-gray-700 focus:border-blue-500 focus:bg-white focus:outline-none"
                type="text"
                value={event.date}
                readOnly
              />
            </div>

            <div className="mb-4 inline-block w-64">
              <label className="mb-1 block text-sm font-bold tracking-wide text-gray-800">
                Select a theme
              </label>
              <div className="relative">
                <select
                  onChange={(e) =>
                    setEvent({ ...event, theme: e.target.value })
                  }
                  value={event.theme}
                  className="block w-full appearance-none rounded-lg border-2 border-gray-200 bg-gray-200 px-4 py-2 pr-8 leading-tight text-gray-700 hover:border-gray-500 focus:border-blue-500 focus:bg-white focus:outline-none"
                >
                  {themes.map((theme, index) => (
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
                className="mr-2 rounded-lg border border-gray-300 bg-white py-2 px-4 font-semibold text-gray-700 shadow-sm hover:bg-gray-100"
                onClick={() => setOpenEventModal(!openEventModal)}
              >
                Cancel
              </button>
              <button
                type="button"
                className="rounded-lg border border-gray-700 bg-gray-800 py-2 px-4 font-semibold text-white shadow-sm hover:bg-gray-700"
                onClick={addEvent}
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

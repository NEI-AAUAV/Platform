import {
  useState,
  useEffect,
  useCallback,
  useLayoutEffect,
  useRef,
} from "react";

import { useWindowSize } from "utils/hooks";
import { ArrowForwardIcon, ArrowBackIcon } from "assets/icons/google";

import service from "services/GoogleCalendarService";

import { locales } from "./data";
import { categories } from "../data";

import { dateKey, getWeeklyIntervals } from "./utils";

import { useLoading } from "utils/hooks";

import CalendarMonth from "./CalendarMonth";
import { motion, AnimatePresence } from "framer-motion";

const calendarEvents = { _all: {} };

const variants = {
  enter: (direction) => {
    return {
      x: direction > 0 ? 1000 : -1000,
      opacity: 0,
    };
  },
  center: {
    zIndex: 1,
    x: 0,
    opacity: 1,
  },
  exit: (direction) => {
    return {
      zIndex: 0,
      x: direction < 0 ? 1000 : -1000,
      opacity: 0,
    };
  },
};

/**
 * Experimenting with distilling swipe offset and velocity into a single variable, so the
 * less distance a user has swiped, the more velocity they need to register as a swipe.
 * Should accomodate longer swipes and short flicks without having binary checks on
 * just distance thresholds and velocity > 0.
 */
const swipeConfidenceThreshold = 10000;
const swipePower = (offset, velocity) => {
  return Math.abs(offset) * velocity;
};

const NEICalendar = () => {
  const windowSize = useWindowSize();
  const [month, setMonth] = useState(3);
  const [year, setYear] = useState(2023);
  const [direction, setDirection] = useState(0);

  // const [calendarEvents, setCalendarEvents] = useState(calendarEventsMemory);
  const [selEvent, setSelEvent] = useState(null);
  const [loading, setLoading] = useLoading(false);

  const [height, setHeight] = useState(0);
  const elementRef = useRef(null);

  useLayoutEffect(() => {
    if (elementRef.current?.firstChild) {
      setHeight(elementRef.current.firstChild.offsetHeight);
    }
  }, [elementRef.current?.firstChild, []]);

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
    if (loading) {
      fetchEvents();
    }
  }, [loading]);

  function handleMonthChange(month) {
    setTimeout(() => {
      const lapsedYears = Math.floor(month / 12);
      setYear(year + lapsedYears);
      const lapsedMonths = month % 12;
      setMonth((prevMonth) => {
        setDirection(month > prevMonth ? 1 : -1);
        return lapsedMonths >= 0 ? lapsedMonths : 12 + lapsedMonths;
      });
    }, 300); // TODO: think about this
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
    setLoading(true);
  }, [year, month]);

  const fetchEvents = () => {
    function addMonthEvents(date) {
      const [year, month] = [date.getFullYear(), date.getMonth()];
      const monthKey = dateKey(year, month);

      if (monthKey in calendarEvents) {
        // Month events already in memory
        return;
      }
      calendarEvents[monthKey] = {};

      const daysInMonth = new Date(year, month + 1, 0).getDate(),
        firstMonthDay = new Date(year, month, 1).getDay(),
        lastMonthDay = new Date(year, month + 1, 0).getDay(),
        daySince = 1 - firstMonthDay,
        dayTo = daysInMonth + 6 - lastMonthDay;

      for (let day = daySince; day <= dayTo; day++) {
        const dayKey = dateKey(year, month, day);
        const events = [];
        calendarEvents._all[dayKey] = { unfetched: true, events };
        calendarEvents[monthKey][dayKey] = events;
      }
      return [new Date(year, month, daySince), new Date(year, month, dayTo)];
    }

    let calendarSince, calendarTo, range;
    if ((range = addMonthEvents(new Date(year, month)))) {
      [calendarSince, calendarTo] = range;
    }
    if ((range = addMonthEvents(new Date(year, month - 1)))) {
      calendarSince = range[0];
      calendarTo = calendarTo || range[1];
    }
    if ((range = addMonthEvents(new Date(year, month + 1)))) {
      calendarSince = calendarSince || range[0];
      calendarTo = range[1];
    }

    if (!calendarSince || !calendarTo) {
      // Data already fetched
      setLoading(false);
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
      let events = [];

      for (const e of data.items) {
        let start = new Date(e.start.date || e.start.dateTime);
        let end = new Date(e.end.date || e.end.dateTime);
        if (e.end.date) {
          // Google API considers end date as the day after the event at midnight,
          // so one day is substracted
          end.setDate(end.getDate() - 1);
        }

        events = events.concat(
          getWeeklyIntervals(start, end)
            .map(({ weekStart, weekEnd }) => ({
              id: e["id"],
              title: e["summary"],
              allDay: "date" in e["start"],
              category: getCategory(e["summary"]),
              weekStart,
              start,
              end,
              duration:
                Math.ceil(
                  (weekEnd.getTime() - weekStart.getTime()) /
                    (1000 * 60 * 60 * 24)
                ) + 1,
            }))
            // Select events in the calendar range and not already fetched
            .filter((e) => calendarEvents._all[dateKey(e.weekStart)]?.unfetched)
        );
      }

      // Assign events to a day slot in a way that they don't overlap
      // and fit the free slots efficiently
      for (const e of events) {
        const calendarDate = calendarEvents._all[dateKey(e.weekStart)];
        if (!calendarDate) {
          // Event is out of the calendar range
          continue;
        }
        calendarDate.unfetched = false;

        // Find first free slot
        const index = [...calendarDate.events, undefined].findIndex(
          (e) => e === undefined
        );
        calendarDate.events[index] = e;
        for (let i = 1; i < e.duration; i++) {
          const date = new Date(e.weekStart);
          date.setDate(date.getDate() + i);
          // Occupy the next slots adjacent
          calendarEvents._all[dateKey(date)].events[index] = null;
        }
      }
      setLoading(false);
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
        <div
          className="overflow-hidden rounded-lg bg-base-200 shadow"
          data-dialog-container
        >
          <div className="flex items-center justify-between px-6 py-2">
            <div>
              <span className="text-lg font-bold text-base-content">
                {locales.pt.months[month]}
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

          <div className="w-full">
            <div className="grid grid-cols-7">
              {(windowSize.width < 768
                ? locales.pt.daysMin
                : locales.pt.daysShort
              ).map((day, index) => (
                <div className="py-2" key={index}>
                  <div className="text-center text-sm font-bold uppercase tracking-wide text-gray-600">
                    {day}
                  </div>
                </div>
              ))}
            </div>
            <motion.div
              style={{ height: height }}
              animate={{ height: height }}
              transition={{ duration: 0.3 }}
              className="relative -mb-[2px] -ml-px box-content w-full pl-px pr-[2px]"
            >
              <AnimatePresence initial={false} custom={direction}>
                <motion.div
                  id={month}
                  ref={elementRef}
                  className="absolute inset-0"
                  key={month}
                  custom={direction}
                  variants={variants}
                  initial="enter"
                  animate="center"
                  exit="exit"
                  transition={{
                    x: { ease: "easeOut", duration: 0.3 },
                    opacity: { duration: 0.2 },
                  }}
                  drag="x"
                  dragConstraints={{ left: 0, right: 0 }}
                  dragElastic={1}
                  onDragEnd={(e, { offset, velocity }) => {
                    const swipe = swipePower(offset.x, velocity.x);

                    if (swipe < -swipeConfidenceThreshold) {
                      handleMonthChange(month + 1);
                    } else if (swipe > swipeConfidenceThreshold) {
                      handleMonthChange(month - 1);
                    }
                  }}
                >
                  <CalendarMonth
                    month={month}
                    monthEvents={calendarEvents[dateKey(year, month)]}
                    selEvent={selEvent}
                    setSelEvent={setSelEvent}
                  />
                </motion.div>
              </AnimatePresence>
            </motion.div>
          </div>
        </div>
      </div>

      {/* Modal */}
      {/* <div
        style={{ backgroundColor: "rgba(0, 0, 0, 0.8)", display: "none" }}
        className="fixed bottom-0 left-0 right-0 top-0 z-40 h-full w-full"
      >
        {" "}
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
      </div> */}
    </div>
  );
};

export default NEICalendar;

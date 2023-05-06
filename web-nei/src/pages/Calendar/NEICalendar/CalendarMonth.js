import classNames from "classnames";
import { Fragment } from "react";

import { EventDialog } from "components/Dialog";
import { dateKey } from "./utils";


const CalendarMonth = ({ month, monthEvents, selEvent, setSelEvent }) => {
  function isToday(date) {
    return dateKey(new Date()) === date;
  }

  if (!monthEvents) return null;

  return (
    <div className="grid grid-cols-7 border-l border-t border-base-content/10">
      {Object.entries(monthEvents).map(([day, events], index) => (
        <Fragment key={index}>
          <div className="min-h-[120px] border-b border-r border-base-content/10">
            <div
              // onClick={() => showEventModal(day)}
              className={classNames(
                "m-2 inline-flex h-6 w-6 cursor-pointer items-center justify-center rounded-full leading-none transition duration-100 ease-in-out",
                {
                  "bg-secondary text-secondary-content": isToday(day),
                  "hover:bg-secondary/50": !isToday(day),
                  "text-base-content/50": new Date(day).getMonth() !== month,
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
                      onShowChange={(show) => !show && setSelEvent(null)}
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
                          background: `hsl(${event?.category?.color} / ${
                            selected ? 1 : 0.7
                          })`,
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
          </div>
        </Fragment>
      ))}
    </div>
  );
};

export default CalendarMonth;

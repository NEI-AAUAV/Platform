import { motion } from "framer-motion";
import React, { useEffect, useRef } from "react";
import classname from "classname";

import { ArrowBackIcon, ArrowForwardIcon } from "assets/icons/google";

/**
 * Receives an array of strings and renders a tab for each one of them.
 * @param {Array} tabs
 * @param {Any} value
 * @param {Function} onChange
 * @param {String} renderTab optional
 * @param {String} underlineColor optional
 * @param {String} className optional
 */
const Tabs = ({ tabs, value, onChange, renderTab, underlineColor, className }) => {
  const tabsRef = useRef(null);
  const [scrollPos, setScrollPos] = React.useState(null);
  const [focused, setFocused] = React.useState(null);
  const [selected, setSelected] = React.useState(value || tabs?.[0]);

  useEffect(() => {
    setSelected(value);
  }, [value]);

  useEffect(() => {
    /**
     * Sets the scroll percentage of the tabs container to
     * disable the scroll buttons when the tabs are at the end.
     */
    const setScrollPercentage = () => {
      setScrollPos(
        tabsRef.current.scrollLeft /
          (tabsRef.current.scrollWidth - tabsRef.current.clientWidth)
      );
    };

    if (tabsRef.current) {
      setScrollPercentage();
      tabsRef.current.addEventListener("scroll", () => {
        setScrollPercentage();
      });
      window.addEventListener("resize", () => {
        setScrollPercentage();
      });
    }

    return () => {
      if (tabsRef.current) {
        tabsRef.current.removeEventListener("scroll", null);
        window.removeEventListener("resize", null);
      }
    };
  }, [tabsRef]);

  function scroll(value) {
    tabsRef.current.scrollBy(value, 0);
  }

  return (
    <div className={`flex justify-center ${className}`}>
      <div className="rounded-l-box my-1 flex items-center justify-center bg-base-200/80 px-2">
        <div
          className={classname("btn-ghost btn-sm btn-circle btn", {
            "btn-disabled bg-transparent": isNaN(scrollPos) || scrollPos < 0.01,
          })}
          onClick={() => scroll(-300)}
        >
          <ArrowBackIcon />
        </div>
      </div>
      <div
        ref={tabsRef}
        className="scrollbar-hide w-fit max-w-3xl overflow-y-scroll scroll-smooth"
      >
        <ul
          className="my-1 flex w-fit list-none items-center bg-base-200/80 px-4 py-1"
          onMouseLeave={() => setFocused(null)}
        >
          {tabs?.map((item) => (
            <li
              className="relative flex cursor-pointer items-center"
              key={item}
              onClick={() => onChange(item)}
              onKeyDown={(event) =>
                event.key === "Enter" ? onChange(item) : null
              }
              onFocus={() => setFocused(item)}
              onMouseEnter={() => setFocused(item)}
              tabIndex={0}
            >
              <span
                className={classname(
                  "relative z-10 select-none px-6 py-2 font-bold",
                  {
                    "opacity-75": selected !== item,
                  }
                )}
              >
                {renderTab?.(item) || item}
              </span>

              {selected === item ? (
                <div className="absolute left-0 right-0 top-0 bottom-0 z-0 rounded-lg bg-base-300/80 shadow" />
              ) : null}

              {focused === item ? (
                <motion.div
                  transition={{
                    layout: {
                      duration: 0.2,
                      ease: "easeOut",
                    },
                  }}
                  className="absolute left-0 right-0 top-0 bottom-0 z-0 rounded-lg bg-base-300/80"
                  layoutId="highlight"
                />
              ) : null}

              {selected === item ? (
                <motion.div
                  className={classname(
                    "absolute bottom-[-6px] left-1/4 z-0 h-1 w-1/2 rounded-lg",
                    underlineColor ? underlineColor : "!bg-accent"
                  )}
                  layoutId="underline"
                />
              ) : null}
            </li>
          ))}
        </ul>
      </div>
      <div className="rounded-r-box my-1 flex items-center justify-center bg-base-200/80 px-2">
        <div
          className={classname("btn-ghost btn-sm btn-circle btn", {
            "btn-disabled bg-transparent": isNaN(scrollPos) || scrollPos > 0.99,
          })}
          name="forward"
          onClick={() => scroll(300)}
        >
          <ArrowForwardIcon />
        </div>
      </div>
    </div>
  );
};

export default Tabs;

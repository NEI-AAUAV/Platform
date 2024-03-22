import { useState, useRef, useEffect, useMemo } from "react";
import classNames from "classnames";
import { useWindowSize } from "utils/hooks";

import { motion, AnimatePresence } from "framer-motion";

import { EventIcon, CloseIcon } from "assets/icons/google";

import "./index.css";

export const EventDialog = ({ event, show, onShowChange, ...dialogProps }) => {
  // NOTE: calling setVisible will result in a loop, call handleVisible instead
  const [visible, setVisible] = useState(show || false);
  const controlled = show !== undefined && onShowChange !== undefined;

  useEffect(() => {
    // Update child state from parent
    if (controlled) {
      setVisible(show);
    }
  }, [show]);

  useEffect(() => {
    // Update parent state from child
    onShowChange?.(visible);
  }, [visible]);

  function handleVisible(value) {
    // Useful to avoid state update loops
    if (controlled) {
      onShowChange(value);
    } else {
      setVisible(value);
    }
  }

  function formatDateRange(start, end) {
    if (!start || !end) return;
    const startMonthYear = start.toLocaleString("pt-PT", {
      month: "long",
      year: "numeric",
    });
    const endMonthYear = end.toLocaleString("pt-PT", {
      month: "long",
      year: "numeric",
    });
    const startDay = start.getDate();
    const endDay = end.getDate();

    return startMonthYear !== endMonthYear
      ? `${startDay} de ${startMonthYear} – ${endDay} de ${endMonthYear}`
      : startDay !== endDay
      ? `${startDay} – ${endDay} de ${startMonthYear}`
      : `${startDay} de ${startMonthYear}`;
  }

  const eventDialog = useMemo(() => {
    if (!event) return null;
    return (
      <>
        <div className="flex items-start gap-3">
          <div
            className="mr-1 rounded-full p-1 text-base-300"
            style={{ background: `hsl(${event.category?.color})` }}
          >
            <EventIcon />
          </div>
          <h5 className="font-medium">{event.category?.name}</h5>

          <div className="ml-auto gap-3">
            <div
              className="btn-ghost btn-sm btn-circle btn"
              onClick={() => handleVisible(false)}
            >
              <CloseIcon />
            </div>
          </div>
        </div>
        <h4 className="mt-2 font-semibold">{event.title}</h4>
        <p className="mt-2 opacity-80">
          {formatDateRange(event.start, event.end)}
        </p>
      </>
    );
  }, [event]);

  return (
    <Dialog
      {...dialogProps}
      dialog={eventDialog}
      show={visible}
      layoutId="event-dialog"
      onShowChange={handleVisible}
    />
  );
};

/**
 * A dialog to display additional information when clicking on a component.
 *
 * @param {ReactNode} dialog - the content of the dialog
 * @param {ReactNode} children - the component that triggers the dialog
 * @param {string} className - the class name of the dialog
 * @param {string} layoutId - the layoutId of all dialog siblings to animate
 * @param {boolean} [show] - used to control the dialog visibility outside
 * @param {function} [onShowChange] - used to propagate visible state outside
 */
const Dialog = ({
  dialog,
  children,
  className,
  layoutId,
  show,
  onShowChange,
}) => {
  // NOTE: calling setVisible will result in a loop, call handleVisible instead
  const [visible, setVisible] = useState(show || false);
  const controlled = show !== undefined && onShowChange !== undefined;

  // This helps avoiding multiple listeners to be set up
  const [listenToClick, setListenToClick] = useState(false);
  const [dialogPos, setDialogPos] = useState("top-right");

  const childrenRef = useRef(null);
  const dialogRef = useRef(null);
  const windowSize = useWindowSize();

  useEffect(() => {
    if (!listenToClick) return;

    // show dialog on outside click
    function handleClickOutside(event) {
      function isInsideBoundingBox(event, element) {
        if (!element) return false;

        const rect = element.getBoundingClientRect();
        return (
          event.clientX >= rect.left &&
          event.clientX <= rect.right &&
          event.clientY >= rect.top &&
          event.clientY <= rect.bottom
        );
      }
      if (!isInsideBoundingBox(event, dialogRef.current)) {
        handleVisible(false);
      }
    }
    document.addEventListener("click", handleClickOutside, true);
    return () => {
      document.removeEventListener("click", handleClickOutside, true);
    };
  }, [listenToClick]);

  useEffect(() => {
    // Update child state from parent
    if (controlled) {
      setVisible(show);
    }
  }, [show]);

  useEffect(() => {
    // Update parent state from child
    onShowChange?.(visible);

    if (!visible) {
      // Remove click outside listener
      setListenToClick(false);
      return;
    }

    setDialogPos(findBestDialogPosition());
    // Add click outside listener
    setListenToClick(true);
  }, [visible]);

  function handleVisible(value) {
    // Useful to avoid state update loops
    if (controlled) {
      onShowChange(value);
    } else {
      setVisible(value);
    }
  }

  function findBestDialogPosition() {
    if (!childrenRef.current) return "top-right";

    const { top, bottom, left, right } =
      childrenRef.current.getBoundingClientRect();

    // TODO: good for now, but should be improved
    // (overflow-hidden in parent hides dialog in some positions)
    // try using a custom parent container to calculate position
    // ( childrenRef.current.closest("[data-dialog-container]") )
    const { innerWidth, innerHeight } = window;

    const leftSpace = left,
      rightSpace = innerWidth - right,
      topSpace = top,
      bottomSpace = innerHeight - bottom;

    return (
      (bottomSpace > topSpace ? "top-" : "bottom-") +
      (leftSpace > rightSpace ? "right" : "left")
    );
  }

  return (
    <div className={`relative w-fit ${className}`}>
      <div
        ref={childrenRef}
        tabIndex="0"
        role="button"
        onClick={() => handleVisible(true)}
      >
        {children}
      </div>
      <AnimatePresence>
        {visible && (
          <motion.div
            initial={{ opacity: 1, zIndex: 40 }}
            animate={{ opacity: 1, zIndex: 40 }}
            exit={{ opacity: 0, zIndex: 50 }}
            transition={{ duration: 0.3 }}
            layoutId={layoutId}
            ref={dialogRef}
            role="dialog"
            className={classNames(
              "absolute min-w-[380px] rounded-lg border border-base-content/10 bg-base-300 p-4 shadow-md",
              windowSize.width >= 640
                ? `Dialog Dialog--${dialogPos}`
                : "!fixed !min-w-[280px] left-1 right-1 top-20"
            )}
          >
            {dialog}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};

export default Dialog;

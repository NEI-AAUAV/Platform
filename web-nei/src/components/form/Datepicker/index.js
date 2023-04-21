import { useEffect, forwardRef } from "react";
import FlowbiteDatepicker from "flowbite-datepicker/Datepicker";
import {
  CalendarIcon,
  ArrowBackIcon,
  ArrowForwardIcon,
} from "assets/icons/google";
import { renderToString } from "react-dom/server";
import classNames from "classnames";
import locale from "../../../../node_modules/flowbite-datepicker/js/i18n/locales/pt";
import "./index.css";

// Hack to add locale pt to Datepicker
FlowbiteDatepicker.locales.pt = locale.pt;

const Datepicker = forwardRef(
  ({ id, label, value, onChange, error, ...props }, ref) => {
    useEffect(() => {
      const datepickerEl = document.querySelector("[data-datepicker]");
      new FlowbiteDatepicker(datepickerEl, {
        language: "pt",
        prevArrow: renderToString(<ArrowBackIcon />),
        nextArrow: renderToString(<ArrowForwardIcon />),
      });
    }, []);

    return (
      <>
        {!!label && (
          <label htmlFor={id} className="label">
            <span className="label-text">{label}</span>
          </label>
        )}
        <div className="relative">
          <input
            ref={ref}
            type="text"
            className={classNames(
              "input-bordered input w-full pr-12",
              error && "!input-error"
            )}
            onSelect={(e) => {
              e.target?.value && onChange(e);
            }}
            onClick={(e) => console.log(e.target.value)}
            onChange={() => {}}
            value={value}
            data-datepicker
            id={id}
            {...props}
          />
          <div className="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-4">
            <CalendarIcon />
          </div>
        </div>
        {!!error && (
          <p className="message-error">
            {error?.message}
          </p>
        )}
      </>
    );
  }
);

export default Datepicker;

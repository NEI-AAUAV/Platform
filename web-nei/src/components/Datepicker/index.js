import React, { useEffect, useState } from "react";
import FlowbiteDatepicker from "flowbite-datepicker/Datepicker";
import { CalendarIcon, ArrowBackIcon, ArrowForwardIcon } from "assets/icons/google";
import { renderToString } from 'react-dom/server'
import locale from "../../../node_modules/flowbite-datepicker/js/i18n/locales/pt";
import "./index.css";

// Hack to add locale pt to Datepicker
FlowbiteDatepicker.locales.pt = locale.pt;

const Datepicker = ({id, placeholder, value, onChange, ...props}) => {

  useEffect(() => {
    const datepickerEl = document.querySelector('[data-datepicker]')
    new FlowbiteDatepicker(datepickerEl, {
        language: 'pt',
        prevArrow: renderToString(<ArrowBackIcon />),
        nextArrow: renderToString(<ArrowForwardIcon />),
    });
    
  }, []);

  return (
    <div className="relative" {...props}>
      <input
        type="text"
        className="input-bordered input w-full pr-12"
        onSelect={(e) => e.target.value && value !== e.target.value && onChange(e.target.value)}
        // onClick={(e) => console.log(e.target.value)}
        onChange={() => {}}
        placeholder={placeholder}
        value={value}
        data-datepicker
        id={id}
      />
      <div className="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-4">
        <CalendarIcon />
      </div>
    </div>
  );
}

export default Datepicker;

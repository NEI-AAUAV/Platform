import classname from "classnames";
import React, { memo, useRef, useState, useEffect } from "react";

import { CloseIcon, ExpandMoreIcon } from "assets/icons/google";

/**
 * Autocomplete input.
 *
 * @param {String[]} items
 * @param {String} value
 * @param {Function} onChange
 */
const Autocomplete = ({ items, value, onChange, placeholder }) => {
  const ref = useRef(null);
  const [text, setText] = useState("");
  const [options, setOptions] = useState(items);
  const [open, setOpen] = useState(false);

  useEffect(() => {
    if (!text) {
      setOptions(items);
      return;
    }
    const newItems = items.filter((i) =>
      i.toLowerCase().includes(text.toLowerCase())
    );

    setOptions(newItems);
  }, [text]);

  useEffect(() => {
    setText(value);
  }, [value]);

  function reset(e) {
    onChange("");
    e.preventDefault();
  }

  return (
    <div
      className={classname("text-left font-medium", {
        "dropdown w-full": true,
        "dropdown-open": open,
      })}
      ref={ref}
    >
      <input
        type="text"
        className="input-bordered input w-full placeholder:font-normal placeholder:text-base-content/50"
        value={text}
        onChange={(e) => setText(e.target.value)}
        // Reset text to selected value
        onBlur={() => setText(value)}
        placeholder={placeholder}
        tabIndex={0}
      />
      <div className="absolute right-3 top-1/2 flex !-translate-y-1/2 items-center gap-2 text-base-content/25">
        {!!value && (
          <button
            className="btn-ghost btn-xs btn-circle btn text-base-content"
            onClick={reset}
          >
            <CloseIcon />
          </button>
        )}
        <ExpandMoreIcon />
      </div>
      <div className="dropdown-content rounded-box top-14 overflow-hidden border border-base-300 bg-base-200 shadow">
        <div className="max-h-96 w-full overflow-y-auto overflow-x-hidden">
          <ul
            className="menu menu-compact p-2"
            // Use ref to calculate the width of parent
            style={{ width: ref.current?.clientWidth }}
          >
            {!options?.length && (
              <li className="px-3 py-2 text-sm opacity-60">Sem resultados</li>
            )}
            {options?.map((item, index) => (
              <li key={index} tabIndex={index + 1}>
                <span
                  // Hack to prevent calling onBlur on input
                  onMouseDown={(e) => e.preventDefault()}
                  onClick={(e) => onChange(item)}
                  className={classname({
                    "btn-disabled font-bold": item === value,
                  })}
                >
                  {item}
                </span>
              </li>
            ))}
          </ul>
        </div>
      </div>
    </div>
  );
};

export default Autocomplete;

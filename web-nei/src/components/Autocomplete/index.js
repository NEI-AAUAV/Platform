import classNames from "classnames";
import React, { memo, useRef, useState, useEffect } from "react";

import { CloseIcon, ExpandMoreIcon } from "assets/icons/google";

/**
 * Autocomplete input.
 *
 * @param {Array[{key: String, label: String}]} items
 * @param {String} value the selected item's key
 * @param {Function} onChange callback to be called when an item is selected
 */
const Autocomplete = ({ items, value, onChange, placeholder, renderOption }) => {
  const ref = useRef(null);
  const [text, setText] = useState("");
  const [options, setOptions] = useState(items);

  useEffect(() => {
    setOptions(items);
    resetText();
  }, [items]);

  useEffect(() => {
    if (!text) {
      setOptions(items);
      return;
    }
    if (text !== getLabelSelected()) {
      const newItems = items.filter(({ label }) =>
        label.toLowerCase().includes(text.toLowerCase())
      );
      setOptions(newItems);
    } else {
      setOptions(items);
    }
  }, [text]);

  useEffect(() => {
    resetText();
  }, [value]);

  function getLabelSelected() {
    return items.find((item) => item.key === value)?.label;
  }

  function resetText() {
    setText(getLabelSelected() || "");
  }

  function setValue(value) {
    onChange(value);
    // Hack to close dropdown when item is selected
    document.activeElement.blur();
  }

  return (
    <div className="dropdown w-full text-left font-medium" ref={ref}>
      <input
        type="text"
        className="input-bordered input w-full pr-[4.5rem] placeholder:font-normal placeholder:text-base-content/50"
        value={text}
        onChange={(e) => setText(e.target.value)}
        // Reset text to selected value
        onBlur={resetText}
        placeholder={placeholder}
        tabIndex={0}
      />
      <div className="absolute right-3 top-1/2 flex !-translate-y-1/2 items-center gap-2 text-base-content/25">
        {!!value && items.length > 0 && (
          <button
            className="btn-ghost btn-xs btn-circle btn text-base-content"
            // Hack to prevent calling focus on input
            onMouseDown={(e) => e.preventDefault()}
            onClick={() => setValue("")}
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
                  // Hack to prevent calling blur on input
                  onMouseDown={(e) => e.preventDefault()}
                  onClick={() => setValue(item.key)}
                  className={classNames({
                    "btn-disabled font-bold": item.key === value,
                  })}
                >
                  {renderOption?.(item) || item.label}
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

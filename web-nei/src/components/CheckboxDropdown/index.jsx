/** @jsxRuntime classic */
/** @jsx jsx */
import { css, jsx } from "@emotion/react";
import { useEffect, useState } from "react";

/**
 * A filter dropdown with checkboxes as options
 *
 * @param {Array[{name: String, checked: Boolean}]} values list of options to display
 * @param {Function} onChange callback to be called when a checkbox is checked/unchecked
 */
const CheckboxDropdown = ({ values, onChange, children, className }) => {
  const [options, setOptions] = useState(values);

  useEffect(() => {
    setOptions(values);
  }, [values]);

  return (
    <div className="dropdown-end dropdown">
      <label tabIndex={0} className={`btn ${className}`}>
        {children}
      </label>
      <ul
        tabIndex={0}
        className="dropdown-content menu rounded-box w-52 border border-base-300 bg-base-200 p-2 font-medium shadow"
      >
        {options?.map(
          ({ name, checked, color = "var(--p)"}, index) => (
            <li key={index}>
              <label>
                <input
                  type="checkbox"
                  checked={checked}
                  onChange={() =>
                    onChange((options) => {
                      const newOptions = [...options];
                      newOptions[index].checked = !checked;
                      return newOptions;
                    })
                  }
                  className="checkbox checkbox-sm"
                  // Customize DaisyUI colors
                  css={css`
                    --chkbg: ${color};
                    border-color: hsl(${color});
                    &:checked {
                      background-color: hsl(${color});
                    }
                  `}
                />
                <span className="label-text px-2">{name}</span>
              </label>
            </li>
          )
        )}
      </ul>
    </div>
  );
};

export default CheckboxDropdown;

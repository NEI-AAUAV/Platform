/** @jsxRuntime classic */
/** @jsx jsx */
import { css, jsx } from "@emotion/react";
import { useEffect, useState } from "react";
import classNames from "classnames";

/**
 * A filter dropdown with radio buttons as options
 *
 * @param {Array[{label: String, value: String, checked: Boolean}]} values list of options to display
 * @param {Function} onChange callback to be called when a radio is checked/unchecked
 */
const RadioDropdown = ({ name, values, onChange, children, className, ...props }) => {
  const [options, setOptions] = useState(values);

  useEffect(() => {
    setOptions(values);
  }, [values]);

  return (
    <div className={classNames("dropdown", className?.dropdown)}>
      <label tabIndex={0} className={classNames("btn", className?.label)}>
        {children}
      </label>
      <ul
        tabIndex={0}
        className="dropdown-content menu rounded-box w-52 border border-base-300 bg-base-200 p-2 font-medium shadow"
      >
        {options?.map(
          ({ label, checked, color = "var(--p)" }, index) => (
            <li key={index}>
              <label>
                <input
                  type="radio"
                  name={name}
                  checked={checked}
                  onChange={() => onChange(options[index].value)}
                  className="radio radio-sm"
                  // Customize DaisyUI colorss
                  css={css`
                    --chkbg: ${color};
                    border-color: hsl(${color});
                    &:checked {
                      background-color: hsl(${color});
                    }
                  `}
                />
                <span className="label-text px-2">{label}</span>
              </label>
            </li>
          )
        )}
      </ul>
    </div>
  );
};

export default RadioDropdown;

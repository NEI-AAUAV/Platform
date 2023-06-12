/* eslint-disable react/jsx-props-no-spreading */

import classNames from "classnames";
import { forwardRef } from "react";

interface InputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  className?: string;
  placeholder?: string;
  style?: React.CSSProperties;
  disabled?: boolean;
}

const Input = forwardRef(
  (
    { className, placeholder, style, disabled, ...props }: InputProps,
    ref: React.ForwardedRef<HTMLInputElement>,
  ) => {
    return (
      <div className="p-[2px]">
        <input
          className={classNames(
            "w-full rounded-3xl border border-light-gold px-3 focus:border-transparent focus:outline-none focus:ring-2 focus:ring-light-gold disabled:bg-gray-100",
            className,
          )}
          type="text"
          placeholder={placeholder}
          style={style}
          ref={ref}
          disabled={disabled}
          {...props}
        />
      </div>
    );
  },
);
Input.defaultProps = {
  className: "",
  placeholder: "",
  disabled: false,
  style: {},
};

export default Input;

/* eslint-disable react/jsx-props-no-spreading */

import { forwardRef } from "react";

type InputProps = {
  className?: string;
  placeholder?: string;
  style?: React.CSSProperties;
  props?: React.InputHTMLAttributes<HTMLInputElement>;
};

const Input = forwardRef(
  (
    { className, placeholder, style, props }: InputProps,
    ref: React.ForwardedRef<HTMLInputElement>,
  ) => {
    return (
      <input
        className={`rounded-3xl border border-light-gold focus:border-transparent focus:outline-none focus:ring-2 focus:ring-light-gold ${className}`}
        type="text"
        placeholder={placeholder}
        style={style}
        ref={ref}
        {...props}
      />
    );
  },
);
Input.defaultProps = {
  className: "",
  placeholder: "",
  props: {},
  style: {},
};

export default Input;

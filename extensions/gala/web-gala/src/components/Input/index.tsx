/* eslint-disable react/jsx-props-no-spreading */
import React from "react";

type InputProps = {
  className?: string;
  placeholder?: string;
  style?: React.CSSProperties;
  props?: React.InputHTMLAttributes<HTMLInputElement>;
};

export default function Input({
  className,
  placeholder,
  style,
  props,
}: InputProps) {
  return (
    <input
      className={`rounded-3xl border border-light-gold focus:border-transparent focus:outline-none focus:ring-2 focus:ring-light-gold ${className}`}
      type="text"
      placeholder={placeholder}
      style={style}
      {...props}
    />
  );
}

Input.defaultProps = {
  className: "",
  placeholder: "",
  props: {},
  style: {},
};

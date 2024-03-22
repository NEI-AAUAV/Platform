import { forwardRef } from "react";
import classNames from "classnames";

const Input = forwardRef(
  ({ id, label, error, icon, className, ...props }, ref) => (
    <div className={className}>
      {!!label && (
        <label htmlFor={id} className="label">
          <span className="label-text">{label}</span>
        </label>
      )}
      <div className="relative">
        <input
          ref={ref}
          id={id}
          type="text"
          className={classNames(
            "input-bordered input w-full",
            icon && "pr-12",
            error && "!input-error"
          )}
          {...props}
        />
        <div className="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-4">
          {icon}
        </div>
      </div>
      {!!error && <p className="message-error">{error?.message}</p>}
    </div>
  )
);

export default Input;

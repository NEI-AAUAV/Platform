import { forwardRef } from "react";
import classNames from "classnames";

const FileInput = forwardRef(({ id, label, error, ...props }, ref) => (
  <>
    {!!label && (
      <label htmlFor={id} className="label">
        <span className="label-text">{label}</span>
      </label>
    )}
    <input
      ref={ref}
      id={id}
      type="file"
      className={classNames(
        "file-input-bordered file-input w-full",
        error && "!input-error"
      )}
      {...props}
    />
    {!!error && (
      <p className="message-error">
        {error?.message}
      </p>
    )}
  </>
));

export default FileInput;

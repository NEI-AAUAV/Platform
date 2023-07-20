import classNames from "classnames";

const Select = ({ id, label, type, error, icon, ...props }) => (
    <>
      <label htmlFor={id} className="label">
        <span className="label-text">{label}</span>
      </label>
      {/* Not implemented */}
      <p
        className={classNames("message-error", {
          hidden: !error,
        })}
      >
        {error?.message}
      </p>
    </>
  );
  
  export default Select;
  
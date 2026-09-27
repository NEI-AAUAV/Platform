import React from "react";
import PropTypes from "prop-types";

const SUCCESS_MESSAGE_TIMEOUT = 3000;

export function useStatusMessages() {
  const [error, setError] = React.useState(null);
  const [success, setSuccess] = React.useState(null);
  const timeoutsRef = React.useRef([]);

  React.useEffect(() => {
    return () => {
      timeoutsRef.current.forEach((id) => clearTimeout(id));
      timeoutsRef.current = [];
    };
  }, []);

  const showSuccess = React.useCallback((message) => {
    setSuccess(message);
    const id = setTimeout(() => setSuccess(null), SUCCESS_MESSAGE_TIMEOUT);
    timeoutsRef.current.push(id);
  }, []);

  return { error, setError, success, setSuccess, showSuccess };
}

export default function StatusMessages({ error, onDismissError, success, onDismissSuccess }) {
  return (
    <>
      {error && (
        <div className="alert alert-error my-3" role="alert">
          <span>{error}</span>
          <button className="btn btn-sm btn-circle btn-ghost" onClick={onDismissError} aria-label="Dismiss error">
            ✕
          </button>
        </div>
      )}
      {success && (
        <div className="toast toast-bottom toast-end z-50">
          <div className="alert alert-success" role="status">
            <span>{success}</span>
            <button className="btn btn-sm btn-circle btn-ghost" onClick={onDismissSuccess} aria-label="Dismiss message">
              ✕
            </button>
          </div>
        </div>
      )}
    </>
  );
}

StatusMessages.propTypes = {
  error: PropTypes.string,
  onDismissError: PropTypes.func.isRequired,
  success: PropTypes.string,
  onDismissSuccess: PropTypes.func.isRequired,
};

/**
 * Utility functions for error handling and message extraction.
 */

/**
 * Extract a user-friendly error message from an error object.
 * 
 * Handles various error formats:
 * - FastAPI errors: error.response.data.detail
 * - Generic API errors: error.response.data.message
 * - Axios errors: error.message
 * - String errors: direct string
 * - Unknown errors: default message
 * 
 * @param {Error|string|any} error - The error object or string
 * @param {string} defaultMessage - Default message if no error message found
 * @returns {string} User-friendly error message
 * 
 * @example
 * try {
 *   await api.call();
 * } catch (err) {
 *   const message = getErrorMessage(err, "Operation failed");
 *   toast.error(message);
 * }
 */
export function getErrorMessage(error, defaultMessage = "An error occurred") {
  // Handle string errors (e.g., "Session Expired" from client.jsx)
  if (typeof error === "string") {
    return error;
  }

  // Handle null/undefined
  if (!error) {
    return defaultMessage;
  }

  // FastAPI error format: error.response.data.detail
  if (error?.response?.data?.detail) {
    return error.response.data.detail;
  }

  // Alternative API error format: error.response.data.message
  if (error?.response?.data?.message) {
    return error.response.data.message;
  }

  // Axios/Error message
  if (error?.message) {
    return error.message;
  }

  // Fallback to default
  return defaultMessage;
}

/**
 * Check if an error is a specific HTTP status code.
 * 
 * @param {Error|any} error - The error object
 * @param {number|number[]} statusCode - Status code(s) to check
 * @returns {boolean} True if error matches the status code(s)
 * 
 * @example
 * if (isErrorStatus(err, 404)) {
 *   // Handle not found
 * }
 * 
 * if (isErrorStatus(err, [401, 403])) {
 *   // Handle unauthorized/forbidden
 * }
 */
export function isErrorStatus(error, statusCode) {
  const status = error?.response?.status;
  if (!status) return false;
  
  if (Array.isArray(statusCode)) {
    return statusCode.includes(status);
  }
  
  return status === statusCode;
}

/**
 * Get the HTTP status code from an error.
 * 
 * @param {Error|any} error - The error object
 * @returns {number|null} HTTP status code or null if not available
 * 
 * @example
 * const status = getErrorStatus(err);
 * if (status === 503) {
 *   // Service unavailable
 * }
 */
export function getErrorStatus(error) {
  return error?.response?.status ?? null;
}


import { describe, it, expect } from "vitest";
import { getErrorMessage, isErrorStatus, getErrorStatus } from "../../utils/error";

describe("getErrorMessage", () => {
  it("returns plain strings as they are", () => {
    expect(getErrorMessage("Session Expired")).toBe("Session Expired");
  });

  it("prefers the FastAPI detail over everything else", () => {
    const err = { message: "Request failed", response: { data: { detail: "Nope", message: "x" } } };

    expect(getErrorMessage(err)).toBe("Nope");
  });

  it("falls back to response.data.message, then error.message", () => {
    expect(getErrorMessage({ response: { data: { message: "m" } } })).toBe("m");
    expect(getErrorMessage(new Error("network down"))).toBe("network down");
  });

  it.each([null, undefined, 0, ""])("uses the default for %j", (value) => {
    // "" is a string, so it is returned as is; the others are falsy non-strings
    const expected = value === "" ? "" : "An error occurred";
    expect(getErrorMessage(value)).toBe(expected);
  });

  it("uses the supplied default when nothing descriptive exists", () => {
    expect(getErrorMessage({}, "Custom")).toBe("Custom");
    expect(getErrorMessage({ response: { data: {} } }, "Custom")).toBe("Custom");
  });
});

describe("isErrorStatus / getErrorStatus", () => {
  const err = (status) => ({ response: { status } });

  it("matches a single status code", () => {
    expect(isErrorStatus(err(404), 404)).toBe(true);
    expect(isErrorStatus(err(404), 500)).toBe(false);
  });

  it("matches any of several status codes", () => {
    expect(isErrorStatus(err(403), [401, 403])).toBe(true);
    expect(isErrorStatus(err(500), [401, 403])).toBe(false);
  });

  it("is false when there is no response (e.g. network error)", () => {
    expect(isErrorStatus(new Error("x"), 500)).toBe(false);
    expect(isErrorStatus(null, 500)).toBe(false);
  });

  it("getErrorStatus returns the status or null", () => {
    expect(getErrorStatus(err(418))).toBe(418);
    expect(getErrorStatus(new Error("x"))).toBeNull();
    expect(getErrorStatus(undefined)).toBeNull();
  });
});

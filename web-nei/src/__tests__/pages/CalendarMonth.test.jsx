import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import { render, screen, fireEvent } from "@testing-library/react";

vi.mock("../../components/Dialog", () => ({
  EventDialog: ({ event, children, onShowChange }) => (
    <div data-testid={`dialog-${event?.id}`}>
      {children}
      <button onClick={() => onShowChange(false)}>close-{event?.id}</button>
      <button onClick={() => onShowChange(true)}>open-{event?.id}</button>
    </div>
  ),
}));

import CalendarMonth from "../../pages/Calendar/NEICalendar/CalendarMonth";

const nei = { key: "NEI", color: "131 72% 28%" };
const year1 = { key: "1A", color: "187 99% 45%" };

const event = (id, category, duration = 1) => ({
  id,
  title: `Event ${id}`,
  category,
  duration,
});

function setup(props = {}) {
  const setSelEvent = vi.fn();
  const utils = render(
    <CalendarMonth
      month={8}
      monthEvents={{
        "2026-08-31": [],
        "2026-09-01": [event("a", nei), null],
        "2026-09-02": [event("b", year1), null],
      }}
      selEvent={null}
      setSelEvent={setSelEvent}
      hiddenCategories={new Set()}
      {...props}
    />
  );
  return { ...utils, setSelEvent };
}

describe("CalendarMonth", () => {
  beforeEach(() => {
    vi.useFakeTimers({ toFake: ["Date"] });
    vi.setSystemTime(new Date(2026, 8, 2, 12));
  });
  afterEach(() => {
    vi.useRealTimers();
  });

  it("renders nothing without month events", () => {
    const { container } = render(
      <CalendarMonth
        month={8}
        monthEvents={undefined}
        hiddenCategories={new Set()}
      />
    );
    expect(container).toBeEmptyDOMElement();
  });

  it("renders one cell per day with day numbers", () => {
    setup();
    expect(screen.getByText("31")).toBeInTheDocument();
    expect(screen.getByText("1")).toBeInTheDocument();
    expect(screen.getByText("2")).toBeInTheDocument();
  });

  it("highlights today and dims days from other months", () => {
    setup();
    expect(screen.getByText("2")).toHaveClass("bg-secondary");
    expect(screen.getByText("1")).toHaveClass("hover:bg-secondary/50");
    expect(screen.getByText("31")).toHaveClass("text-base-content/50");
    expect(screen.getByText("1")).not.toHaveClass("text-base-content/50");
  });

  it("renders event badges inside dialogs, empty slots without", () => {
    setup();
    expect(screen.getByTestId("dialog-a")).toBeInTheDocument();
    expect(screen.getByText("Event a")).toBeInTheDocument();
    expect(screen.getAllByTestId(/^dialog-/)).toHaveLength(2);
    // null/undefined slots render an invisible placeholder badge
    expect(document.querySelectorAll(".invisible")).toHaveLength(2);
  });

  it("sets the event category data attribute and badge width", () => {
    setup();
    const badge = screen.getByText("Event a").parentElement;
    expect(badge.closest("[data-category]")).toHaveAttribute(
      "data-category",
      "NEI"
    );
    expect(badge.style.width).toContain("100%");
  });

  it("selects an event on badge click and clears on dialog close", () => {
    const { setSelEvent } = setup();

    fireEvent.click(screen.getByText("Event a"));
    expect(setSelEvent).toHaveBeenCalledWith(
      expect.objectContaining({ id: "a" })
    );

    fireEvent.click(screen.getByText("close-a"));
    expect(setSelEvent).toHaveBeenLastCalledWith(null);

    setSelEvent.mockClear();
    fireEvent.click(screen.getByText("open-a"));
    expect(setSelEvent).not.toHaveBeenCalled();
  });

  it("marks the selected event badge with a shadow", () => {
    setup({ selEvent: event("a", nei) });
    expect(screen.getByText("Event a").parentElement).toHaveClass("shadow-md");
    expect(screen.getByText("Event b").parentElement).not.toHaveClass(
      "shadow-md"
    );
  });

  it("dims events of hidden categories", () => {
    setup({ hiddenCategories: new Set(["1A"]) });
    const hidden = screen.getByText("Event b").closest("[data-category]");
    const visible = screen.getByText("Event a").closest("[data-category]");
    expect(hidden).toHaveClass("pointer-events-none", "opacity-20");
    expect(visible).not.toHaveClass("opacity-20");
  });
});

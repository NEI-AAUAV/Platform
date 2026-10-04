import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import { render, screen, fireEvent, waitFor } from "@testing-library/react";

vi.mock("../../services/GoogleCalendarService", () => ({
  default: { getEvents: vi.fn() },
}));

// Lists the placed events so the test can assert on the calendar's data layer
vi.mock("../../pages/Calendar/NEICalendar/CalendarMonth", () => ({
  default: ({ monthEvents, hiddenCategories }) => (
    <ul data-testid="month" data-hidden={[...hiddenCategories].join(",")}>
      {Object.entries(monthEvents ?? {}).flatMap(([day, events]) =>
        events
          .filter(Boolean)
          .map((e) => (
            <li key={`${day}-${e.id}`} data-testid="event">
              {`${day}|${e.title}|${e.duration}|${e.category.key}|${e.allDay}`}
            </li>
          ))
      )}
    </ul>
  ),
}));

import service from "../../services/GoogleCalendarService";
import NEICalendar from "../../pages/Calendar/NEICalendar";

// The events cache is module-level, so each test uses its own year
function setToday(year, month, day = 15) {
  vi.useFakeTimers({ toFake: ["Date"] });
  vi.setSystemTime(new Date(year, month, day, 12));
}

const allDay = (id, summary, start, end) => ({
  id,
  summary,
  start: { date: start },
  end: { date: end },
});

const eventTexts = () => screen.queryAllByTestId("event").map((e) => e.textContent);

describe("NEICalendar", () => {
  beforeEach(() => {
    service.getEvents.mockReset();
    service.getEvents.mockResolvedValue({ data: { items: [] } });
  });
  afterEach(() => {
    vi.useRealTimers();
    vi.restoreAllMocks();
    window.innerWidth = 1024;
  });

  it("fetches the visible range and places all-day events", async () => {
    setToday(2031, 8);
    service.getEvents.mockResolvedValue({
      data: {
        items: [
          allDay("a", "[NEI] Workshop", "2031-09-10", "2031-09-13"),
          allDay("b", "[GLUA] Other entity", "2031-09-10", "2031-09-11"),
          {
            id: "c",
            start: { dateTime: "2031-09-16T10:00:00+01:00" },
            end: { dateTime: "2031-09-16T10:00:00+01:00" },
          },
        ],
      },
    });

    render(<NEICalendar hiddenCategories={new Set(["1A"])} />);

    await waitFor(() => expect(eventTexts()).toHaveLength(2));
    expect(screen.getByText("Setembro")).toBeInTheDocument();
    expect(screen.getByText("2031")).toBeInTheDocument();
    expect(screen.getByTestId("month")).toHaveAttribute("data-hidden", "1A");

    const { timeMin, timeMax } = service.getEvents.mock.calls[0][0];
    expect(timeMin).toMatch(/^\d{4}-\d+-\d+T00:00:00\+01:00$/);
    expect(timeMax).toMatch(/^\d{4}-\d+-\d+T00:00:00\+01:00$/);

    // End date is exclusive in Google's API: 10 -> 13 spans 3 days
    expect(eventTexts()).toContain("2031-09-10|[NEI] Workshop|3|NEI|true");
    // Event without summary defaults to NEI, other entities are dropped
    expect(eventTexts().some((t) => t.includes("Other entity"))).toBe(false);
    expect(eventTexts().some((t) => t.startsWith("2031-09-16|"))).toBe(true);
  });

  it("splits events that span multiple weeks", async () => {
    setToday(2032, 8);
    service.getEvents.mockResolvedValue({
      data: {
        items: [allDay("w", "[NEI] Long", "2032-09-10", "2032-09-16")],
      },
    });

    render(<NEICalendar hiddenCategories={new Set()} />);

    // Fri 10 -> Wed 15 crosses a week boundary: two weekly segments
    await waitFor(() => expect(eventTexts()).toHaveLength(2));
    expect(eventTexts()[0]).toContain("|[NEI] Long|2|");
    expect(eventTexts()[1]).toContain("|[NEI] Long|");
  });

  it("navigates months without refetching cached ones", async () => {
    setToday(2033, 0);

    render(<NEICalendar hiddenCategories={new Set()} />);
    await waitFor(() => expect(service.getEvents).toHaveBeenCalledTimes(1));
    expect(screen.getByText("Janeiro")).toBeInTheDocument();

    const [prev, next] = screen.getAllByRole("button");

    fireEvent.click(prev);
    expect(await screen.findByText("Dezembro")).toBeInTheDocument();
    expect(screen.getByText("2032")).toBeInTheDocument();

    fireEvent.click(next);
    expect(await screen.findByText("Janeiro")).toBeInTheDocument();
    expect(screen.getByText("2033")).toBeInTheDocument();
    expect(service.getEvents).toHaveBeenCalledTimes(1);
  });

  it("fetches again when moving past the loaded range", async () => {
    setToday(2034, 5);

    render(<NEICalendar hiddenCategories={new Set()} />);
    await waitFor(() => expect(service.getEvents).toHaveBeenCalledTimes(1));
    const next = screen.getAllByRole("button")[1];

    for (const name of ["Julho", "Agosto", "Setembro"]) {
      fireEvent.click(next);
      expect(await screen.findByText(name)).toBeInTheDocument();
    }

    await waitFor(() => expect(service.getEvents).toHaveBeenCalledTimes(2));
  });

  it("rolls over to the next year after December", async () => {
    setToday(2035, 11);

    render(<NEICalendar hiddenCategories={new Set()} />);
    await waitFor(() => expect(service.getEvents).toHaveBeenCalled());

    fireEvent.click(screen.getAllByRole("button")[1]);

    expect(await screen.findByText("Janeiro")).toBeInTheDocument();
    expect(screen.getByText("2036")).toBeInTheDocument();
  });

  it("logs when fetching events fails", async () => {
    setToday(2036, 8);
    const error = vi.spyOn(console, "error").mockImplementation(() => {});
    const failure = new Error("network");
    service.getEvents.mockRejectedValue(failure);

    render(<NEICalendar hiddenCategories={new Set()} />);

    await waitFor(() =>
      expect(error).toHaveBeenCalledWith(
        "Failed to fetch calendar events:",
        failure
      )
    );
  });

  it("uses short weekday labels on small screens", async () => {
    setToday(2037, 8);
    window.innerWidth = 500;

    render(<NEICalendar hiddenCategories={new Set()} />);

    await waitFor(() => expect(service.getEvents).toHaveBeenCalled());
    expect(screen.queryByText("Dom")).not.toBeInTheDocument();
    expect(screen.getAllByText("D")).toHaveLength(1);
  });

  it("uses abbreviated weekday labels on larger screens", async () => {
    setToday(2038, 8);
    window.innerWidth = 1200;

    render(<NEICalendar hiddenCategories={new Set()} />);

    await waitFor(() => expect(service.getEvents).toHaveBeenCalled());
    expect(screen.getByText("Dom")).toBeInTheDocument();
  });
});

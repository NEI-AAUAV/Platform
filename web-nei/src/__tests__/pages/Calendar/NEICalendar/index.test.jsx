import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen, waitFor } from "@testing-library/react";
import NEICalendar from "../../../../pages/Calendar/NEICalendar";

vi.mock("../../../../services/GoogleCalendarService", () => ({
  default: {
    getEvents: vi.fn().mockResolvedValue({ data: { items: [] } }),
  },
}));

vi.mock("../../../../utils/hooks", async () => {
  const actual = await vi.importActual("../../../../utils/hooks");
  return {
    ...actual,
    useWindowSize: () => ({ width: 1024, height: 768 }),
  };
});

vi.mock("../../../../assets/icons/google", () => ({
  ArrowForwardIcon: () => <span data-testid="arrow-forward-icon">Next</span>,
  ArrowBackIcon: () => <span data-testid="arrow-back-icon">Back</span>,
  EventIcon: () => <span data-testid="event-icon">Event</span>,
  CloseIcon: () => <span data-testid="close-icon">Close</span>,
}));

describe("NEICalendar", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("renders the current month and year header", async () => {
    render(<NEICalendar />);

    const now = new Date();
    const expectedYear = String(now.getFullYear());

    await waitFor(() => {
      expect(screen.getByText(expectedYear)).toBeInTheDocument();
    });
  });

  it("renders the weekday headers", async () => {
    render(<NEICalendar />);

    await waitFor(() => {
      expect(screen.getAllByText(/dom|seg|ter|qua|qui|sex|s[áa]b/i).length).toBeGreaterThan(0);
    });
  });

  it("renders month navigation buttons", async () => {
    render(<NEICalendar />);

    await waitFor(() => {
      expect(document.querySelectorAll(".btn-circle").length).toBeGreaterThanOrEqual(2);
    });
  });

  it("does not crash when the calendar service returns no items", async () => {
    render(<NEICalendar />);

    await waitFor(() => {
      expect(document.querySelector(".container")).not.toBeNull();
    });
  });
});

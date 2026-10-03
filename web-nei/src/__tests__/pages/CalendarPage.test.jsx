import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen, fireEvent } from "@testing-library/react";

const mockConfig = vi.hoisted(() => ({ PRODUCTION: false }));
vi.mock("../../config", () => ({ default: mockConfig }));

vi.mock("../../pages/Calendar/NEICalendar", () => ({
  default: ({ hiddenCategories }) => (
    <div data-testid="neicalendar">{[...hiddenCategories].join(",")}</div>
  ),
}));

vi.mock("../../components", () => ({
  TabsButton: ({ tabs, selected, setSelected }) => (
    <div>
      {tabs.map((tab, i) => (
        <button
          key={i}
          role="tab"
          aria-selected={selected === i}
          onClick={() => setSelected(i)}
        >
          {tab}
        </button>
      ))}
    </div>
  ),
}));

vi.mock("../../assets/icons/google", () => ({
  CalendarViewMonthIcon: () => null,
  FilterIcon: () => null,
  ViewAgendaIcon: () => null,
}));

import { Component as Calendar } from "../../pages/Calendar";

describe("Calendar page", () => {
  beforeEach(() => {
    mockConfig.PRODUCTION = false;
  });

  it("shows the month calendar by default with no hidden categories", () => {
    render(<Calendar />);
    expect(screen.getByText("Calendário")).toBeInTheDocument();
    expect(screen.getByTestId("neicalendar")).toHaveTextContent("");
  });

  it("offers the agenda tab outside production", () => {
    render(<Calendar />);
    const tabs = screen.getAllByRole("tab");
    expect(tabs).toHaveLength(2);

    fireEvent.click(tabs[1]);

    expect(screen.queryByTestId("neicalendar")).not.toBeInTheDocument();
    expect(screen.getByText(/Meter uma linda agenda/)).toBeInTheDocument();
  });

  it("hides the unfinished agenda tab in production", () => {
    mockConfig.PRODUCTION = true;
    render(<Calendar />);
    expect(screen.getAllByRole("tab")).toHaveLength(1);
  });

  it("passes unchecked categories to the calendar as hidden", () => {
    render(<Calendar />);

    fireEvent.click(screen.getByLabelText("1º Ano"));
    expect(screen.getByTestId("neicalendar")).toHaveTextContent("1A");

    fireEvent.click(screen.getByLabelText("MEI"));
    expect(screen.getByTestId("neicalendar")).toHaveTextContent("1A,MEI");

    fireEvent.click(screen.getByLabelText("1º Ano"));
    expect(screen.getByTestId("neicalendar")).toHaveTextContent(/^MEI$/);
  });
});

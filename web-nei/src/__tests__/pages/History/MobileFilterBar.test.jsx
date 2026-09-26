import React from "react";
import { describe, it, expect, vi } from "vitest";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

import MobileFilterBar from "../../../pages/History/MobileFilterBar";

const MILESTONES = [
  { id: 1, category: { slug: "fundacao", label: "Fundação", color: "hsl(145 80% 35%)" } },
  { id: 2, category: { slug: "evento", label: "Evento", color: "hsl(210 90% 55%)" } },
];

describe("MobileFilterBar", () => {
  it("renders nothing when there are no categories and no years", () => {
    const { container } = render(
      <MobileFilterBar
        milestones={[]}
        activeCategory={null}
        onCategoryChange={vi.fn()}
        years={[]}
      />
    );
    expect(container).toBeEmptyDOMElement();
  });

  it("calls onCategoryChange when a category is selected", async () => {
    const onCategoryChange = vi.fn();
    const user = userEvent.setup();
    render(
      <MobileFilterBar
        milestones={MILESTONES}
        activeCategory={null}
        onCategoryChange={onCategoryChange}
        years={[2024]}
      />
    );

    await user.selectOptions(
      screen.getByRole("combobox", { name: "Filtrar por categoria" }),
      "evento"
    );

    expect(onCategoryChange).toHaveBeenCalledWith("evento");
  });

  it("scrolls to the chosen year and resets the select", async () => {
    const scrollIntoView = vi.fn();
    document.body.innerHTML = '<div id="history-year-2024"></div>';
    document.getElementById("history-year-2024").scrollIntoView = scrollIntoView;

    const user = userEvent.setup();
    render(
      <MobileFilterBar
        milestones={MILESTONES}
        activeCategory={null}
        onCategoryChange={vi.fn()}
        years={[2024, 2018]}
      />
    );

    const yearSelect = screen.getByRole("combobox", { name: "Saltar para ano" });
    await user.selectOptions(yearSelect, "2024");

    expect(scrollIntoView).toHaveBeenCalledWith({ behavior: "smooth", block: "start" });
    expect(yearSelect).toHaveValue("");
  });
});

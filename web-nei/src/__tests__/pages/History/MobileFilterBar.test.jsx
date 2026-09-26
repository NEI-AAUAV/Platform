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
  it("renders nothing when there are no categories and no mandates", () => {
    const { container } = render(
      <MobileFilterBar
        milestones={[]}
        activeCategory={null}
        onCategoryChange={vi.fn()}
        mandates={[]}
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
        mandates={["2024/25"]}
      />
    );

    await user.selectOptions(
      screen.getByRole("combobox", { name: "Filtrar por categoria" }),
      "evento"
    );

    expect(onCategoryChange).toHaveBeenCalledWith("evento");
  });

  it("scrolls to the chosen mandate and resets the select", async () => {
    const scrollIntoView = vi.fn();
    document.body.innerHTML = '<div id="history-mandato-2024-25"></div>';
    document.getElementById("history-mandato-2024-25").scrollIntoView = scrollIntoView;

    const user = userEvent.setup();
    render(
      <MobileFilterBar
        milestones={MILESTONES}
        activeCategory={null}
        onCategoryChange={vi.fn()}
        mandates={["2024/25", "2017/18"]}
      />
    );

    const mandateSelect = screen.getByRole("combobox", { name: "Saltar para mandato" });
    await user.selectOptions(mandateSelect, "2024/25");

    expect(scrollIntoView).toHaveBeenCalledWith({ behavior: "smooth", block: "start" });
    expect(mandateSelect).toHaveValue("");
  });
});

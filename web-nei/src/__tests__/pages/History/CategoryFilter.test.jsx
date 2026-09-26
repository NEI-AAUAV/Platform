import React from "react";
import { describe, it, expect, vi } from "vitest";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

import CategoryFilter from "../../../pages/History/CategoryFilter";

const FUNDACAO = { slug: "fundacao", label: "Fundação", color: "hsl(145 80% 35%)" };
const EVENTO = { slug: "evento", label: "Evento", color: "hsl(210 90% 55%)" };

const milestones = [
  { id: 1, category: FUNDACAO },
  { id: 2, category: EVENTO },
  { id: 3, category: null },
  { id: 4, category: EVENTO },
];

describe("CategoryFilter", () => {
  it("renders nothing when no milestone has a category", () => {
    const { container } = render(
      <CategoryFilter milestones={[{ id: 1, category: null }]} active={null} onChange={vi.fn()} />
    );
    expect(container).toBeEmptyDOMElement();
  });

  it("renders one chip per distinct category used, plus 'Todos'", () => {
    render(<CategoryFilter milestones={milestones} active={null} onChange={vi.fn()} />);

    expect(screen.getByRole("button", { name: "Todos" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Fundação" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "Evento" })).toBeInTheDocument();
    // No milestone here uses "Conquista", so it shouldn't render a chip.
    expect(screen.queryByRole("button", { name: "Conquista" })).not.toBeInTheDocument();
  });

  it("marks 'Todos' active when nothing is selected", () => {
    render(<CategoryFilter milestones={milestones} active={null} onChange={vi.fn()} />);
    expect(screen.getByRole("button", { name: "Todos" })).toHaveClass("is-active");
  });

  it("marks the matching chip active", () => {
    render(<CategoryFilter milestones={milestones} active="evento" onChange={vi.fn()} />);
    expect(screen.getByRole("button", { name: "Evento" })).toHaveClass("is-active");
    expect(screen.getByRole("button", { name: "Todos" })).not.toHaveClass("is-active");
  });

  it("calls onChange with the category when clicked", async () => {
    const onChange = vi.fn();
    const user = userEvent.setup();
    render(<CategoryFilter milestones={milestones} active={null} onChange={onChange} />);

    await user.click(screen.getByRole("button", { name: "Fundação" }));
    expect(onChange).toHaveBeenCalledWith("fundacao");
  });

  it("toggles off when clicking the already-active chip", async () => {
    const onChange = vi.fn();
    const user = userEvent.setup();
    render(<CategoryFilter milestones={milestones} active="evento" onChange={onChange} />);

    await user.click(screen.getByRole("button", { name: "Evento" }));
    expect(onChange).toHaveBeenCalledWith(null);
  });

  it("calls onChange with null when 'Todos' is clicked", async () => {
    const onChange = vi.fn();
    const user = userEvent.setup();
    render(<CategoryFilter milestones={milestones} active="evento" onChange={onChange} />);

    await user.click(screen.getByRole("button", { name: "Todos" }));
    expect(onChange).toHaveBeenCalledWith(null);
  });
});

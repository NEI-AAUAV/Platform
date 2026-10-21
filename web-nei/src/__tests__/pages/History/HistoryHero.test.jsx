import React from "react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen } from "@testing-library/react";

const motion = vi.hoisted(() => ({ reduced: false }));

vi.mock("framer-motion", () => ({
  motion: {
    h1: ({ children, className, id }) => (
      <h1 className={className} id={id}>
        {children}
      </h1>
    ),
  },
  useReducedMotion: () => motion.reduced,
}));

vi.mock("react-simple-typewriter", () => ({
  Typewriter: () => <span data-testid="typewriter" />,
}));

import HistoryHero from "../../../pages/History/HistoryHero";

const MILESTONES = [
  { id: 1, moment: "1993-11-05" },
  { id: 2, moment: "2018-05-01" },
  { id: 3, moment: "2024-02-01" },
];

describe("HistoryHero", () => {
  beforeEach(() => {
    motion.reduced = false;
  });

  it("types the title, keeping one plain copy for screen readers", () => {
    render(<HistoryHero milestones={MILESTONES} />);

    expect(screen.getByTestId("typewriter")).toBeInTheDocument();
    expect(screen.getByRole("heading", { level: 1, name: "História do NEI" })).toBeInTheDocument();
  });

  it("shows the title as plain text with reduced motion", () => {
    motion.reduced = true;
    render(<HistoryHero milestones={MILESTONES} />);

    expect(screen.queryByTestId("typewriter")).not.toBeInTheDocument();
    expect(screen.getByRole("heading", { level: 1 })).toHaveTextContent("História do NEI");
  });

  it("states only what the data says: first year and milestone count", () => {
    render(<HistoryHero milestones={MILESTONES} />);

    expect(screen.getByText("Desde").nextSibling).toHaveTextContent("1993");
    expect(screen.getByText("Marcos").nextSibling).toHaveTextContent("3");
    expect(screen.queryByText(/anos de história/i)).not.toBeInTheDocument();
  });

  it("shows no stats without milestones", () => {
    render(<HistoryHero milestones={[]} />);
    expect(screen.queryByText("Desde")).not.toBeInTheDocument();
  });
});

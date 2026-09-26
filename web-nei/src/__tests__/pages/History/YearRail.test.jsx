import React from "react";
import { describe, it, expect, vi, afterEach } from "vitest";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

import YearRail from "../../../pages/History/YearRail";

describe("YearRail", () => {
  afterEach(() => {
    document.body.innerHTML = "";
  });

  it("renders nothing when there are no years", () => {
    const { container } = render(<YearRail years={[]} activeYear={null} />);
    expect(container).toBeEmptyDOMElement();
  });

  it("renders one button per year", () => {
    render(<YearRail years={[2024, 2022, 1993]} activeYear={null} />);
    expect(screen.getByRole("button", { name: "2024" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "2022" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "1993" })).toBeInTheDocument();
  });

  it("marks the active year", () => {
    render(<YearRail years={[2024, 2022]} activeYear={2022} />);
    expect(screen.getByRole("button", { name: "2022" })).toHaveClass("is-active");
    expect(screen.getByRole("button", { name: "2024" })).not.toHaveClass("is-active");
  });

  it("scrolls the matching year section into view on click", async () => {
    const section = document.createElement("section");
    section.id = "history-year-2022";
    section.scrollIntoView = vi.fn();
    document.body.appendChild(section);

    const user = userEvent.setup();
    render(<YearRail years={[2022]} activeYear={null} />);
    await user.click(screen.getByRole("button", { name: "2022" }));

    expect(section.scrollIntoView).toHaveBeenCalledWith({
      behavior: "smooth",
      block: "start",
    });
  });

  it("does not throw when the target year section is missing from the DOM", async () => {
    const user = userEvent.setup();
    render(<YearRail years={[2022]} activeYear={null} />);
    await expect(user.click(screen.getByRole("button", { name: "2022" }))).resolves.not.toThrow();
  });
});

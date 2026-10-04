import React from "react";
import { describe, it, expect, vi, afterEach } from "vitest";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

import MandateRail from "../../../pages/History/MandateRail";

describe("MandateRail", () => {
  afterEach(() => {
    document.body.innerHTML = "";
  });

  it("renders nothing when there are no mandates", () => {
    const { container } = render(<MandateRail mandates={[]} activeMandate={null} />);
    expect(container).toBeEmptyDOMElement();
  });

  it("renders one button per mandate", () => {
    render(<MandateRail mandates={["2024/25", "1993/94"]} activeMandate={null} />);
    expect(screen.getByRole("button", { name: "2024/25" })).toBeInTheDocument();
    expect(screen.getByRole("button", { name: "1993/94" })).toBeInTheDocument();
  });

  it("marks the active mandate", () => {
    render(<MandateRail mandates={["2024/25", "2022/23"]} activeMandate="2022/23" />);
    const active = screen.getByRole("button", { name: "2022/23" });
    expect(active).toHaveClass("is-active");
    expect(active).toHaveAttribute("aria-current", "true");
    expect(screen.getByRole("button", { name: "2024/25" })).not.toHaveClass("is-active");
  });

  it("scrolls the matching mandate section into view on click", async () => {
    const section = document.createElement("section");
    section.id = "history-mandato-2022-23";
    section.scrollIntoView = vi.fn();
    document.body.appendChild(section);

    const user = userEvent.setup();
    render(<MandateRail mandates={["2022/23"]} activeMandate={null} />);
    await user.click(screen.getByRole("button", { name: "2022/23" }));

    expect(section.scrollIntoView).toHaveBeenCalledWith({
      behavior: "smooth",
      block: "start",
    });
  });

  it("does not throw when the target section is missing from the DOM", async () => {
    const user = userEvent.setup();
    render(<MandateRail mandates={["2022/23"]} activeMandate={null} />);
    await expect(
      user.click(screen.getByRole("button", { name: "2022/23" }))
    ).resolves.not.toThrow();
  });
});

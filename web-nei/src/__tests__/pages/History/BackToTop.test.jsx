import React from "react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen, act } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

vi.mock("../../../components/MaterialSymbol", () => ({
  default: ({ icon }) => <span data-testid={`icon-${icon}`} />,
}));

import BackToTop from "../../../pages/History/BackToTop";

function fireScroll(y) {
  Object.defineProperty(window, "scrollY", { value: y, configurable: true });
  act(() => {
    window.dispatchEvent(new Event("scroll"));
  });
}

describe("BackToTop", () => {
  beforeEach(() => {
    Object.defineProperty(window, "scrollY", { value: 0, configurable: true });
  });

  it("is hidden until the page is scrolled past the threshold", () => {
    render(<BackToTop />);
    expect(screen.queryByRole("button", { name: "Voltar ao topo" })).not.toBeInTheDocument();

    fireScroll(700);
    expect(screen.getByRole("button", { name: "Voltar ao topo" })).toBeInTheDocument();
  });

  it("scrolls to the top when clicked", async () => {
    const scrollTo = vi.fn();
    window.scrollTo = scrollTo;
    const user = userEvent.setup();
    render(<BackToTop />);

    fireScroll(700);
    await user.click(screen.getByRole("button", { name: "Voltar ao topo" }));

    expect(scrollTo).toHaveBeenCalledWith({ top: 0, behavior: "smooth" });
  });
});

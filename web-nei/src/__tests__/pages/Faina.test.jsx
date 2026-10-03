import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import { vi } from "vitest";
import { Component as Faina } from "../../pages/Faina";
import service from "../../services/NEIService";

vi.mock("../../services/NEIService", () => ({ default: { getFainaMandates: vi.fn() } }));
vi.mock("react-simple-typewriter", () => ({ Typewriter: ({ words }) => <>{words[0]}</> }));
vi.mock("framer-motion", async () => {
  const React = await import("react");
  const strip = ({ children, initial, animate, exit, transition, variants, layoutId, ...rest }, Tag) =>
    React.createElement(Tag, rest, children);
  return {
    AnimatePresence: ({ children }) => <>{children}</>,
    motion: { div: (p) => strip(p, "div") },
  };
});
vi.mock("assets/abstract", () => ({
  DecorativeSepTop: () => null,
  DecorativeSepMiddle: () => null,
  DecorativeSepBottom: () => null,
}));

const mandates = [
  {
    mandate: "23/24",
    image: null,
    members: [{ role: { name: "Mestre" }, name: "Ana", member: null }],
  },
  {
    mandate: "24/25",
    image: "http://img/f.png",
    members: [
      { role: { name: "Mestre" }, name: "", member: { name: "Rui", surname: "Costa" } },
      { role: { name: "Caloiro" }, name: "Zé", member: null },
    ],
  },
];

describe("Faina page", () => {
  let errSpy;
  beforeEach(() => {
    vi.clearAllMocks();
    Element.prototype.scrollBy = vi.fn();
    errSpy = vi.spyOn(console, "error").mockImplementation(() => {});
  });
  afterEach(() => errSpy.mockRestore());

  it("selects newest mandate and lists members with name fallback", async () => {
    service.getFainaMandates.mockResolvedValue(mandates);
    render(<Faina />);
    expect(await screen.findByText(/Rui Costa/)).toBeInTheDocument();
    expect(screen.getByText(/Zé/)).toBeInTheDocument();
    expect(screen.getByAltText(/Comissão de Faina/)).toHaveAttribute("src", "http://img/f.png");
    expect(screen.getByText(/Comissão de Faina \/25/)).toBeInTheDocument();
  });

  it("switches mandate on tab click and drops image", async () => {
    service.getFainaMandates.mockResolvedValue(mandates);
    render(<Faina />);
    await screen.findByText(/Rui Costa/);
    fireEvent.click(screen.getByRole("tab", { name: /23/ }));
    expect(await screen.findByText(/Ana/)).toBeInTheDocument();
    expect(screen.queryByRole("img")).not.toBeInTheDocument();
  });

  it("logs errors and stops loading", async () => {
    service.getFainaMandates.mockRejectedValue(new Error("down"));
    render(<Faina />);
    await waitFor(() =>
      expect(errSpy).toHaveBeenCalledWith("Failed to load Faina members:", expect.any(Error))
    );
    expect(errSpy).toHaveBeenCalledWith("Failed to load Faina mandates:", expect.any(Error));
  });

  it("handles empty mandate list", async () => {
    service.getFainaMandates.mockResolvedValue([]);
    render(<Faina />);
    await waitFor(() => expect(screen.getByText(/Comissão de Faina/, { selector: "h4" })).toBeInTheDocument());
  });
});

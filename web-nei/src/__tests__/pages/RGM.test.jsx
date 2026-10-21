import { render, screen } from "@testing-library/react";
import { vi } from "vitest";
import { Component as RGM } from "../../pages/RGM";
import service from "../../services/NEIService";

vi.mock("../../services/NEIService", () => ({
  default: { getRGMMandates: vi.fn(), getRGM: vi.fn() },
}));
vi.mock("react-simple-typewriter", () => ({ Typewriter: ({ words }) => <>{words[0]}</> }));
vi.mock("framer-motion", async () => {
  const React = await import("react");
  const strip = ({ children, initial, animate, exit, transition, variants, ...rest }, Tag) =>
    React.createElement(Tag, rest, children);
  return { motion: { tbody: (p) => strip(p, "tbody"), tr: (p) => strip(p, "tr") } };
});

const docs = [
  { id: 1, category: "ATA", mandate: "2024/25", title: "Ata 1", file: "/a.pdf", date: null },
  { id: 2, category: "ACR", mandate: "2024/25", title: "Anexo", file: "/b.pdf", date: null },
];

describe("RGM page", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    Element.prototype.scrollBy = vi.fn();
    service.getRGMMandates.mockResolvedValue({ data: ["2024/25"] });
    service.getRGM.mockResolvedValue(docs);
  });

  it("numbers atas and spells out the ACR category", async () => {
    render(<RGM />);
    expect(await screen.findByText(/ATA Número 1/)).toBeInTheDocument();
    expect(screen.getByText(/Anexo Complementar RAC 2024\/25/)).toBeInTheDocument();
  });
});

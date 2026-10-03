import { render, screen, fireEvent } from "@testing-library/react";
import { vi } from "vitest";
import { Component as Sports } from "../../pages/Sports";

const navigate = vi.fn();
vi.mock("react-router-dom", () => ({ useNavigate: () => navigate }));
vi.mock("react-simple-typewriter", () => ({ Typewriter: ({ words }) => <>{words[0]}</> }));
vi.mock("../../pages/Sports/Game", () => ({ default: () => null }));
vi.mock("../../pages/Sports/DetiHall", () => ({ default: () => null }));

describe("Sports page", () => {
  beforeEach(() => navigate.mockClear());

  it("renders heading, carousel and modalities", () => {
    render(<Sports />);
    expect(screen.getByText("Taça UA")).toBeInTheDocument();
    expect(screen.getByText("Modalidades")).toBeInTheDocument();
    expect(screen.getAllByText("Futsal Masculino").length).toBeGreaterThan(0);
  });

  it("navigates on click and on Enter/Space, ignoring other keys", () => {
    render(<Sports />);
    const first = document.querySelector(".modalidade");
    fireEvent.click(first);
    fireEvent.keyDown(first, { key: "Enter" });
    fireEvent.keyDown(first, { key: " " });
    expect(navigate).toHaveBeenCalledTimes(3);
    expect(navigate).toHaveBeenCalledWith("/taca-ua/1");
    fireEvent.keyDown(first, { key: "a" });
    expect(navigate).toHaveBeenCalledTimes(3);
  });
});

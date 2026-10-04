import { render, screen, waitFor } from "@testing-library/react";
import { MemoryRouter } from "react-router-dom";
import { vi } from "vitest";
import { Component as Error404 } from "../../pages/Error404";
import service from "../../services/NEIService";

vi.mock("../../services/NEIService", () => ({
  default: { getRedirects: vi.fn() },
}));

const renderAt = (path) =>
  render(
    <MemoryRouter initialEntries={[path]}>
      <Error404 />
    </MemoryRouter>
  );

describe("Error404 page", () => {
  const originalLocation = window.location;

  beforeEach(() => {
    vi.clearAllMocks();
    delete window.location;
    window.location = { href: "" };
  });
  afterEach(() => {
    window.location = originalLocation;
  });

  it("shows 404 without calling API for /404", async () => {
    renderAt("/404");
    expect(await screen.findByText("Error 404")).toBeInTheDocument();
    expect(service.getRedirects).not.toHaveBeenCalled();
  });

  it("redirects when alias resolves", async () => {
    service.getRedirects.mockResolvedValue({ redirect: "https://example.com/x" });
    renderAt("/Alias");
    expect(await screen.findByText("A redirecionar")).toBeInTheDocument();
    expect(service.getRedirects).toHaveBeenCalledWith({ alias: "alias" });
    await waitFor(() => expect(window.location.href).toBe("https://example.com/x"));
  });

  it("falls back to 404 when alias lookup fails", async () => {
    service.getRedirects.mockRejectedValue(new Error("nf"));
    renderAt("/missing");
    expect(await screen.findByText("Error 404")).toBeInTheDocument();
  });

  it("shows spinner while loading", () => {
    service.getRedirects.mockReturnValue(new Promise(() => {}));
    renderAt("/pending");
    expect(screen.queryByText("Error 404")).not.toBeInTheDocument();
  });
});

import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";
import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { MemoryRouter, Route, Routes } from "react-router-dom";
import { QueryClient, QueryClientProvider } from "react-query";

const svc = vi.hoisted(() => ({ magicLink: vi.fn() }));
vi.mock("../../../services/NEIService", () => ({ default: svc }));

const { Component } = await import("../../../pages/auth/MagicLink/index");

beforeEach(() => {
  svc.magicLink.mockReset();
  vi.spyOn(console, "log").mockImplementation(() => {});
});

function renderPage(url = "/magic?token=tok") {
  const client = new QueryClient({ defaultOptions: { mutations: { retry: false } } });
  return render(
    <QueryClientProvider client={client}>
      <MemoryRouter initialEntries={[url]}>
        <Routes>
          <Route path="/magic" element={<Component />} />
          <Route path="/" element={<div>home page</div>} />
        </Routes>
      </MemoryRouter>
    </QueryClientProvider>
  );
}

const fill = async (password, confirmation) => {
  await userEvent.type(screen.getByPlaceholderText("Password"), password);
  await userEvent.type(screen.getByPlaceholderText("Confirmar password"), confirmation);
  await userEvent.click(screen.getByRole("button", { name: /criar palavra-passe/i }));
};

describe("MagicLink", () => {
  it("sets the password with the link token and goes home", async () => {
    svc.magicLink.mockResolvedValue({});
    renderPage();

    await fill("s3cret", "s3cret");

    await waitFor(() => expect(svc.magicLink).toHaveBeenCalled());
    expect(svc.magicLink.mock.calls[0][0]).toEqual({ password: "s3cret", token: "tok" });
    expect(await screen.findByText("home page")).toBeInTheDocument();
  });

  it("does not submit when the confirmation differs", async () => {
    renderPage();

    await fill("one", "two");

    expect(await screen.findByText("As passwords não coincidem")).toBeInTheDocument();
    expect(svc.magicLink).not.toHaveBeenCalled();
  });

  it("does not submit empty passwords", async () => {
    renderPage();

    await userEvent.click(screen.getByRole("button", { name: /criar palavra-passe/i }));

    expect(await screen.findAllByText("A password não pode estar vazia")).not.toHaveLength(0);
    expect(svc.magicLink).not.toHaveBeenCalled();
  });

  it("tells the user to contact an admin on a client error (e.g. used link)", async () => {
    svc.magicLink.mockRejectedValue({ response: { status: 400 } });
    renderPage();

    await fill("pw", "pw");

    expect(await screen.findByText(/algo correu mal/i)).toBeInTheDocument();
    expect(screen.getByText(/contacte um administrador/i)).toBeInTheDocument();
    expect(screen.queryByText("home page")).not.toBeInTheDocument();
  });

  it("reports a server error on 5xx", async () => {
    svc.magicLink.mockRejectedValue({ response: { status: 503 } });
    renderPage();

    await fill("pw", "pw");

    expect(await screen.findByText(/erro de servidor/i)).toBeInTheDocument();
    expect(screen.queryByText(/contacte um administrador/i)).not.toBeInTheDocument();
  });

  it("shows only the generic message when the failure has no HTTP status", async () => {
    svc.magicLink.mockRejectedValue(new Error("network"));
    renderPage();

    await fill("pw", "pw");

    expect(await screen.findByText(/algo correu mal/i)).toBeInTheDocument();
    expect(screen.queryByText(/contacte um administrador/i)).not.toBeInTheDocument();
    expect(screen.queryByText(/erro de servidor/i)).not.toBeInTheDocument();
  });
});

import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";
import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { MemoryRouter, Route, Routes, useLocation } from "react-router-dom";

const svc = vi.hoisted(() => ({
  forgotPassword: vi.fn(),
  resetPassword: vi.fn(),
  verifyEmail: vi.fn(),
}));
vi.mock("../../../services/NEIService", () => ({ default: svc }));

const { Component: ForgotPassword } = await import("../../../pages/auth/ForgotPassword/index");
const { Component: ResetPassword } = await import("../../../pages/auth/ResetPassword/index");
const { Component: EmailVerify } = await import("../../../pages/auth/EmailVerify/index");

beforeEach(() => {
  Object.values(svc).forEach((fn) => fn.mockReset());
  vi.spyOn(console, "error").mockImplementation(() => {});
});

function Where() {
  const loc = useLocation();
  return <div data-testid="where">{loc.pathname}</div>;
}

const renderAt = (url, Page) =>
  render(
    <MemoryRouter initialEntries={[url]}>
      <Routes>
        <Route path="/page" element={<Page />} />
        <Route path="*" element={<Where />} />
      </Routes>
    </MemoryRouter>
  );

describe("ForgotPassword", () => {
  it("sends the typed email and confirms success", async () => {
    svc.forgotPassword.mockResolvedValue({});
    renderAt("/page", ForgotPassword);

    await userEvent.type(screen.getByLabelText("Email"), "ana@ua.pt");
    await userEvent.click(screen.getByRole("button", { name: /recuperar conta/i }));

    await waitFor(() => expect(svc.forgotPassword).toHaveBeenCalledTimes(1));
    const form = svc.forgotPassword.mock.calls[0][0];
    expect(form).toBeInstanceOf(FormData);
    expect(form.get("email")).toBe("ana@ua.pt");
    const success = screen.getByText(/enviado com sucesso/i);
    await waitFor(() => expect(success).not.toHaveClass("hidden"));
    expect(screen.getByText(/erro a enviar/i)).toHaveClass("hidden");
  });

  it("shows an error and marks the field when sending fails", async () => {
    svc.forgotPassword.mockRejectedValue(new Error("400"));
    renderAt("/page", ForgotPassword);

    await userEvent.type(screen.getByLabelText("Email"), "ana@ua.pt");
    await userEvent.click(screen.getByRole("button", { name: /recuperar conta/i }));

    await waitFor(() => expect(screen.getByText(/erro a enviar/i)).not.toHaveClass("hidden"));
    expect(screen.getByLabelText("Email")).toHaveClass("input-error");
    expect(screen.getByText(/enviado com sucesso/i)).toHaveClass("hidden");
  });

  it("clears a previous error after a successful retry", async () => {
    svc.forgotPassword.mockRejectedValueOnce(new Error("x")).mockResolvedValueOnce({});
    renderAt("/page", ForgotPassword);
    const submit = () => userEvent.click(screen.getByRole("button", { name: /recuperar conta/i }));

    await userEvent.type(screen.getByLabelText("Email"), "ana@ua.pt");
    await submit();
    await waitFor(() => expect(screen.getByLabelText("Email")).toHaveClass("input-error"));
    await submit();

    await waitFor(() => expect(screen.getByLabelText("Email")).not.toHaveClass("input-error"));
    expect(screen.getByText(/erro a enviar/i)).toHaveClass("hidden");
  });
});

describe("ResetPassword", () => {
  it("submits the new password with the token from the link, then goes home", async () => {
    svc.resetPassword.mockResolvedValue({});
    renderAt("/page?token=abc123", ResetPassword);

    await userEvent.type(screen.getByLabelText(/nova password/i), "new-secret");
    await userEvent.click(screen.getByRole("button"));

    await waitFor(() => expect(svc.resetPassword).toHaveBeenCalledTimes(1));
    const [form, params] = svc.resetPassword.mock.calls[0];
    expect(form.get("password")).toBe("new-secret");
    expect(params).toEqual({ token: "abc123" });
    await waitFor(() => expect(screen.getByTestId("where")).toHaveTextContent("/"));
  });

  it("stays on the page and shows an error when the token is rejected", async () => {
    svc.resetPassword.mockRejectedValue(new Error("401"));
    renderAt("/page?token=bad", ResetPassword);

    await userEvent.type(screen.getByLabelText(/nova password/i), "x");
    await userEvent.click(screen.getByRole("button"));

    await waitFor(() => expect(screen.getByText(/erro a alterar a password/i)).not.toHaveClass("hidden"));
    expect(screen.queryByTestId("where")).not.toBeInTheDocument();
  });

  it("sends a null token when the link has none (server then rejects it)", async () => {
    svc.resetPassword.mockResolvedValue({});
    renderAt("/page", ResetPassword);

    await userEvent.type(screen.getByLabelText(/nova password/i), "x");
    await userEvent.click(screen.getByRole("button"));

    await waitFor(() => expect(svc.resetPassword.mock.calls[0][1]).toEqual({ token: null }));
  });
});

describe("EmailVerify", () => {
  it("verifies the token from the link and reports success", async () => {
    svc.verifyEmail.mockResolvedValue({});
    renderAt("/page?token=tok", EmailVerify);

    expect(await screen.findByText(/email validado com sucesso/i)).toBeInTheDocument();
    expect(svc.verifyEmail).toHaveBeenCalledWith({ token: "tok" });
    expect(screen.getByRole("link", { name: /página inicial/i })).toHaveAttribute("href", "/");
  });

  it("reports an invalid link when the server rejects the token", async () => {
    svc.verifyEmail.mockRejectedValue(new Error("401"));
    renderAt("/page?token=bad", EmailVerify);

    expect(await screen.findByText(/link de verificação inválido/i)).toBeInTheDocument();
  });

  it("fails immediately without calling the server when there is no token", async () => {
    renderAt("/page", EmailVerify);

    expect(await screen.findByText(/link de verificação inválido/i)).toBeInTheDocument();
    expect(svc.verifyEmail).not.toHaveBeenCalled();
  });

  it("shows a spinner while the verification is pending", () => {
    svc.verifyEmail.mockReturnValue(new Promise(() => {}));
    const { container } = renderAt("/page?token=tok", EmailVerify);

    expect(screen.queryByText(/email validado/i)).not.toBeInTheDocument();
    expect(screen.queryByText(/inválido/i)).not.toBeInTheDocument();
    expect(container.firstChild).toBeInTheDocument();
  });
});

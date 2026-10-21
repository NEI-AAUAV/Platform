import React from "react";
import { describe, it, expect, vi } from "vitest";
import { render, screen } from "@testing-library/react";

vi.mock("../../../components/MaterialSymbol", () => ({
  default: ({ icon }) => <span data-testid={`icon-${icon}`} />,
}));

import HistoryEmpty from "../../../pages/History/HistoryEmpty";

describe("HistoryEmpty", () => {
  it("renders the empty-state copy", () => {
    render(<HistoryEmpty variant="empty" />);
    expect(screen.getByText("Ainda não há marcos publicados")).toBeInTheDocument();
    expect(screen.getByTestId("icon-history_edu")).toBeInTheDocument();
  });

  it("renders the error-state copy", () => {
    render(<HistoryEmpty variant="error" />);
    expect(screen.getByText("Não foi possível carregar a história")).toBeInTheDocument();
    expect(screen.getByTestId("icon-error")).toBeInTheDocument();
  });
});

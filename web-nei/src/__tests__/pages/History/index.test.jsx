import React from "react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { MemoryRouter } from "react-router-dom";

vi.mock("../../../services/NEIService", () => ({
  default: { getHistory: vi.fn(), getHistoryGallery: vi.fn() },
}));

vi.mock("../../../components/MaterialSymbol", () => ({
  default: ({ icon }) => <span data-testid={`icon-${icon}`} />,
}));

vi.mock("react-markdown", () => ({
  default: ({ children }) => <p>{children}</p>,
}));

import service from "../../../services/NEIService";
import { Component as HistoryPage } from "../../../pages/History";

function renderPage(initialEntries = ["/history"]) {
  return render(
    <MemoryRouter initialEntries={initialEntries}>
      <HistoryPage />
    </MemoryRouter>
  );
}

const MILESTONES = [
  {
    id: 1,
    moment: "1993-11-05",
    title: "Fundação do NEI",
    body: "O núcleo é fundado.",
    image: null,
    category: { slug: "fundacao", label: "Fundação", color: "hsl(145 80% 35%)" },
    featured: true,
    mandate: "1993/94",
    external_url: null,
    external_label: null,
    media: [],
    has_drive_gallery: true,
  },
  {
    id: 2,
    moment: "2018-05-01",
    title: "Lançamento da TacaUA",
    body: "Primeira edição.",
    image: null,
    category: { slug: "evento", label: "Evento", color: "hsl(210 90% 55%)" },
    featured: false,
    mandate: "2017/18",
    external_url: null,
    external_label: null,
    media: [],
    has_drive_gallery: false,
  },
];

describe("History page", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("shows a loading skeleton before the request resolves", () => {
    service.getHistory.mockReturnValue(new Promise(() => {}));
    const { container } = renderPage();

    expect(container.querySelector('[aria-busy="true"]')).toBeInTheDocument();
  });

  it("renders the hero and milestones once loaded", async () => {
    service.getHistory.mockResolvedValue(MILESTONES);
    renderPage();

    expect(await screen.findByText("Fundação do NEI")).toBeInTheDocument();
    expect(screen.getByText("Lançamento da TacaUA")).toBeInTheDocument();
    // Hero milestone count stat.
    expect(screen.getByText("2")).toBeInTheDocument();
  });

  it("shows the error state when the request fails", async () => {
    service.getHistory.mockRejectedValue(new Error("network down"));
    renderPage();

    expect(
      await screen.findByText("Não foi possível carregar a história")
    ).toBeInTheDocument();
  });

  it("shows the empty state when there are no published milestones", async () => {
    service.getHistory.mockResolvedValue([]);
    renderPage();

    expect(
      await screen.findByText("Ainda não há marcos publicados")
    ).toBeInTheDocument();
  });

  it("filters milestones by category via the mobile category select", async () => {
    service.getHistory.mockResolvedValue(MILESTONES);
    const user = userEvent.setup();
    renderPage();

    await screen.findByText("Fundação do NEI");
    await user.selectOptions(
      screen.getByRole("combobox", { name: "Filtrar por categoria" }),
      "evento"
    );

    expect(screen.getByText("Lançamento da TacaUA")).toBeInTheDocument();
    expect(screen.queryByText("Fundação do NEI")).not.toBeInTheDocument();
  });

  it("reads the initial category filter from the URL", async () => {
    service.getHistory.mockResolvedValue(MILESTONES);
    renderPage(["/history?categoria=evento"]);

    await waitFor(() =>
      expect(screen.getByText("Lançamento da TacaUA")).toBeInTheDocument()
    );
    expect(screen.queryByText("Fundação do NEI")).not.toBeInTheDocument();
    expect(
      screen.getByRole("combobox", { name: "Filtrar por categoria" })
    ).toHaveValue("evento");
  });

  it("clears the filter and shows every milestone again", async () => {
    service.getHistory.mockResolvedValue(MILESTONES);
    const user = userEvent.setup();
    renderPage();

    const select = () =>
      screen.getByRole("combobox", { name: "Filtrar por categoria" });

    await screen.findByText("Fundação do NEI");
    await user.selectOptions(select(), "evento");
    expect(screen.queryByText("Fundação do NEI")).not.toBeInTheDocument();

    await user.selectOptions(select(), "");
    expect(screen.getByText("Fundação do NEI")).toBeInTheDocument();
    expect(screen.getByText("Lançamento da TacaUA")).toBeInTheDocument();
  });

  it("opens the gallery lightbox from a milestone card", async () => {
    service.getHistory.mockResolvedValue(MILESTONES);
    service.getHistoryGallery.mockResolvedValue({
      id: 1,
      title: "Fundação do NEI",
      media: [],
    });
    const user = userEvent.setup();
    renderPage();

    await screen.findByText("Fundação do NEI");
    await user.click(screen.getAllByRole("button", { name: /ver galeria/i })[0]);

    await waitFor(() => expect(service.getHistoryGallery).toHaveBeenCalledWith(1));
  });

  it("groups milestones into year sections", async () => {
    service.getHistory.mockResolvedValue(MILESTONES);
    renderPage();

    await screen.findByText("Fundação do NEI");
    expect(screen.getByRole("heading", { name: "1993" })).toBeInTheDocument();
    expect(screen.getByRole("heading", { name: "2018" })).toBeInTheDocument();
  });
});

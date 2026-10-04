import React from "react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { MemoryRouter, useLocation } from "react-router-dom";

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

let location;
function LocationSpy() {
  location = useLocation();
  return null;
}

function renderPage(initialEntries = ["/history"]) {
  return render(
    <MemoryRouter initialEntries={initialEntries}>
      <HistoryPage />
      <LocationSpy />
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
    gallery_count: null,
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
    gallery_count: 0,
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

    expect(await screen.findByText("Lançamento da TacaUA")).toBeInTheDocument();
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

    await waitFor(() =>
      expect(service.getHistoryGallery).toHaveBeenCalledWith(1, expect.anything())
    );
  });

  it("groups milestones into mandate sections", async () => {
    service.getHistory.mockResolvedValue(MILESTONES);
    renderPage();

    await screen.findByText("Fundação do NEI");
    expect(screen.getByRole("heading", { name: "1993/94" })).toBeInTheDocument();
    expect(screen.getByRole("heading", { name: "2017/18" })).toBeInTheDocument();
  });

  it("puts the open gallery in the URL and removes it on close", async () => {
    service.getHistory.mockResolvedValue(MILESTONES);
    service.getHistoryGallery.mockResolvedValue({ id: 1, title: "x", media: [] });
    const user = userEvent.setup();
    renderPage(["/history?categoria=fundacao"]);

    await screen.findByText("Fundação do NEI");
    await user.click(screen.getByRole("button", { name: /ver galeria/i }));
    expect(new URLSearchParams(location.search).get("marco")).toBe("1");
    expect(new URLSearchParams(location.search).get("categoria")).toBe("fundacao");

    await user.keyboard("{Escape}");
    await waitFor(() =>
      expect(new URLSearchParams(location.search).get("marco")).toBeNull()
    );
    expect(new URLSearchParams(location.search).get("categoria")).toBe("fundacao");
  });

  it("opens the gallery on the linked photo from a shared URL", async () => {
    service.getHistory.mockResolvedValue(MILESTONES);
    service.getHistoryGallery.mockResolvedValue({
      id: 1,
      title: "Fundação do NEI",
      media: [
        { id: "drive:a", url: "a.jpg", thumb: "a-t.jpg", caption: "Foto A", source: "drive" },
        { id: "drive:b", url: "b.jpg", thumb: "b-t.jpg", caption: "Foto B", source: "drive" },
      ],
    });
    renderPage(["/history?marco=1&foto=2"]);

    expect(await screen.findByText("2 / 2")).toBeInTheDocument();
    expect(screen.getByAltText("Foto B")).toBeInTheDocument();
  });

  it("records the current photo in the URL while browsing", async () => {
    service.getHistory.mockResolvedValue(MILESTONES);
    service.getHistoryGallery.mockResolvedValue({
      id: 1,
      title: "Fundação do NEI",
      media: [
        { id: "drive:a", url: "a.jpg", thumb: "a-t.jpg", source: "drive" },
        { id: "drive:b", url: "b.jpg", thumb: "b-t.jpg", source: "drive" },
      ],
    });
    const user = userEvent.setup();
    renderPage(["/history?marco=1"]);

    await screen.findByText("1 / 2");
    await user.click(screen.getByLabelText("Foto seguinte"));
    expect(new URLSearchParams(location.search).get("foto")).toBe("2");
  });

  it("retries loading after an error", async () => {
    service.getHistory
      .mockRejectedValueOnce(new Error("network down"))
      .mockResolvedValueOnce(MILESTONES);
    const user = userEvent.setup();
    renderPage();

    await user.click(await screen.findByRole("button", { name: /tentar de novo/i }));
    expect(await screen.findByText("Fundação do NEI")).toBeInTheDocument();
    expect(service.getHistory).toHaveBeenCalledTimes(2);
  });

  describe("URL state", () => {
    const params = () => new URLSearchParams(location.search);

    it("drops a malformed category slug from the URL and shows everything", async () => {
      service.getHistory.mockResolvedValue(MILESTONES);
      renderPage(["/history?categoria=N%C3%A3o%20existe"]);

      expect(await screen.findByText("Fundação do NEI")).toBeInTheDocument();
      await waitFor(() => expect(params().get("categoria")).toBeNull());
    });

    it("explains a category with no milestones and offers to reset the filter", async () => {
      service.getHistory.mockResolvedValue(MILESTONES);
      const user = userEvent.setup();
      renderPage(["/history?categoria=renomeada"]);

      expect(await screen.findByText("Sem marcos nesta categoria")).toBeInTheDocument();
      expect(screen.queryByText("Fundação do NEI")).not.toBeInTheDocument();
      // A well-formed slug may still exist in the CMS: kept until the user resets.
      expect(params().get("categoria")).toBe("renomeada");
      expect(
        screen.getByRole("combobox", { name: "Filtrar por categoria" })
      ).toHaveValue("renomeada");

      await user.click(screen.getByRole("button", { name: /ver todos os marcos/i }));
      expect(params().get("categoria")).toBeNull();
      expect(screen.getByText("Fundação do NEI")).toBeInTheDocument();
      expect(screen.getByText("Lançamento da TacaUA")).toBeInTheDocument();
    });

    it("keeps a working filter untouched", async () => {
      service.getHistory.mockResolvedValue(MILESTONES);
      renderPage(["/history?categoria=evento"]);

      expect(await screen.findByText("Lançamento da TacaUA")).toBeInTheDocument();
      expect(screen.queryByText("Sem marcos nesta categoria")).not.toBeInTheDocument();
      expect(params().get("categoria")).toBe("evento");
    });

    it.each([
      ["a milestone that doesn't exist", "/history?marco=999&foto=2"],
      ["a milestone without a gallery", "/history?marco=2&foto=2"],
      ["a non-numeric id", "/history?marco=abc"],
    ])("clears a gallery link to %s", async (_case, url) => {
      service.getHistory.mockResolvedValue(MILESTONES);
      renderPage([url]);

      await screen.findByText("Fundação do NEI");
      await waitFor(() => expect(params().get("marco")).toBeNull());
      expect(params().get("foto")).toBeNull();
      expect(screen.queryByRole("dialog")).not.toBeInTheDocument();
      expect(service.getHistoryGallery).not.toHaveBeenCalled();
    });

    it("drops a photo number that isn't one", async () => {
      service.getHistory.mockResolvedValue(MILESTONES);
      service.getHistoryGallery.mockResolvedValue({ id: 1, title: "x", media: [] });
      renderPage(["/history?marco=1&foto=abc"]);

      await waitFor(() => expect(params().get("foto")).toBeNull());
      expect(params().get("marco")).toBe("1");
    });

    it("drops a photo number without a gallery", async () => {
      service.getHistory.mockResolvedValue(MILESTONES);
      renderPage(["/history?foto=3"]);

      await screen.findByText("Fundação do NEI");
      await waitFor(() => expect(params().get("foto")).toBeNull());
    });

    it("rewrites a photo number past the end to the photo actually shown", async () => {
      service.getHistory.mockResolvedValue(MILESTONES);
      service.getHistoryGallery.mockResolvedValue({
        id: 1,
        title: "Fundação do NEI",
        media: [
          { id: "drive:a", url: "a.jpg", thumb: "a-t.jpg", caption: "Foto A", source: "drive" },
          { id: "drive:b", url: "b.jpg", thumb: "b-t.jpg", caption: "Foto B", source: "drive" },
        ],
      });
      renderPage(["/history?marco=1&foto=999"]);

      expect(await screen.findByText("1 / 2")).toBeInTheDocument();
      await waitFor(() => expect(params().get("foto")).toBeNull());
      expect(params().get("marco")).toBe("1");
    });
  });
});

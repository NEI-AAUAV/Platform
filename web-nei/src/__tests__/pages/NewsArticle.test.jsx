import { render, screen } from "@testing-library/react";
import { MemoryRouter, Route, Routes } from "react-router-dom";
import { vi } from "vitest";
import NewsArticle from "../../pages/NewsArticle";
import service from "../../services/NEIService";

vi.mock("../../services/NEIService", () => ({
  default: { getNewsById: vi.fn() },
}));

const renderArticle = () =>
  render(
    <MemoryRouter initialEntries={["/news/1"]}>
      <Routes>
        <Route path="/news/:id" element={<NewsArticle />} />
      </Routes>
    </MemoryRouter>
  );

describe("NewsArticle", () => {
  beforeEach(() => vi.clearAllMocks());

  it("sanitizes article HTML before rendering it", async () => {
    service.getNewsById.mockResolvedValue({
      title: "Titulo",
      created_at: "2024-01-01T00:00:00",
      content:
        '<b>safe</b><img src="x" onerror="window.__xss = true"><script>window.__xss = true</script>',
    });
    const { container } = renderArticle();

    expect(await screen.findByText("Titulo")).toBeInTheDocument();
    expect(container.querySelector("p b")).toHaveTextContent("safe");
    expect(container.querySelector("script")).toBeNull();
    expect(container.querySelector("img[onerror]")).toBeNull();
  });
});

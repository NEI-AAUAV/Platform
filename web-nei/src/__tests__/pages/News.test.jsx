import { render, screen, waitFor } from "@testing-library/react";
import { vi } from "vitest";
import News from "../../pages/News";
import service from "../../services/NEIService";

vi.mock("../../services/NEIService", () => ({
  default: { getNews: vi.fn(), getNewsCategories: vi.fn() },
}));
vi.mock("../../pages/News/NewsList", () => ({ default: () => <div>news-list</div> }));
vi.mock("react-simple-typewriter", () => ({ Typewriter: ({ words }) => <>{words[0]}</> }));

describe("News page", () => {
  let errSpy;
  beforeEach(() => {
    vi.clearAllMocks();
    errSpy = vi.spyOn(console, "error").mockImplementation(() => {});
  });
  afterEach(() => errSpy.mockRestore());

  it("loads categories then news and renders the list", async () => {
    service.getNewsCategories.mockResolvedValue({ data: ["A", "B"] });
    service.getNews.mockResolvedValue({ last: 3 });
    render(<News />);
    expect(await screen.findByText("news-list")).toBeInTheDocument();
    expect(service.getNews).toHaveBeenCalledWith({ page: 1, category: ["A", "B"], size: 9 });
    expect(screen.getByText("Notícias")).toBeInTheDocument();
  });

  it("does not fetch news when there are no categories", async () => {
    service.getNewsCategories.mockResolvedValue({});
    render(<News />);
    await waitFor(() => expect(service.getNewsCategories).toHaveBeenCalled());
    expect(service.getNews).not.toHaveBeenCalled();
  });

  it("logs when categories fail", async () => {
    service.getNewsCategories.mockRejectedValue(new Error("x"));
    render(<News />);
    await waitFor(() =>
      expect(errSpy).toHaveBeenCalledWith("Failed to load news categories", expect.any(Error))
    );
  });

  it("stops loading when news fetch fails", async () => {
    service.getNewsCategories.mockResolvedValue({ data: ["A"] });
    service.getNews.mockRejectedValue(new Error("down"));
    render(<News />);
    expect(await screen.findByText("news-list")).toBeInTheDocument();
    expect(errSpy).toHaveBeenCalledWith("Failed to load news", expect.any(Error));
  });
});

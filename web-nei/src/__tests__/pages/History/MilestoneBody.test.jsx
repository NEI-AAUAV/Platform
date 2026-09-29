import React from "react";
import { describe, it, expect } from "vitest";
import { render, screen } from "@testing-library/react";

import { MilestoneBody } from "../../../pages/History/MilestoneParts";

function renderBody(markdown) {
  return render(<MilestoneBody>{markdown}</MilestoneBody>);
}

// The real react-markdown: these guard what CMS text can do to the page.
describe("MilestoneBody", () => {
  it("renders plain legacy text as a paragraph", () => {
    renderBody("O núcleo é fundado por um grupo de estudantes.");
    expect(screen.getByText("O núcleo é fundado por um grupo de estudantes.").tagName).toBe("P");
  });

  it("caps every heading level below the card title (h3)", () => {
    const { container } = renderBody("# Grande\n\n## Médio\n\n###### Pequeno");

    expect(container.querySelectorAll("h1, h2, h3")).toHaveLength(0);
    expect(screen.getAllByRole("heading", { level: 4 }).map((h) => h.textContent)).toEqual([
      "Grande",
      "Médio",
      "Pequeno",
    ]);
  });

  it("drops raw HTML instead of rendering it", () => {
    const { container } = renderBody('Antes <script>alert(1)</script><b onclick="x()">negrito</b> depois');

    expect(container.querySelector("script, b")).toBeNull();
    expect(container.innerHTML).not.toContain("onclick");
  });

  it("opens links in a new tab without handing over the page", () => {
    renderBody("[notícia](https://example.com/noticia)");

    const link = screen.getByRole("link", { name: "notícia" });
    expect(link).toHaveAttribute("href", "https://example.com/noticia");
    expect(link).toHaveAttribute("target", "_blank");
    expect(link).toHaveAttribute("rel", "noopener noreferrer");
  });

  it("neutralises javascript: links", () => {
    renderBody("[clica](javascript:alert(1))");

    expect(screen.getByText("clica").closest("a")?.getAttribute("href") ?? "").not.toMatch(
      /javascript/i
    );
  });

  it("doesn't embed remote images", () => {
    const { container } = renderBody("![rastreio](https://tracker.example/p.gif)");
    expect(container.querySelector("img")).toBeNull();
  });
});

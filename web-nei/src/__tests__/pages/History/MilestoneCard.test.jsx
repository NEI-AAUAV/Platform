import React from "react";
import { describe, it, expect, vi } from "vitest";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

vi.mock("framer-motion", () => ({
  motion: {
    article: ({ children, className, id }) => (
      <article className={className} id={id}>
        {children}
      </article>
    ),
  },
  useReducedMotion: () => false,
}));

vi.mock("react-markdown", () => ({
  default: ({ children }) => <p>{children}</p>,
}));

vi.mock("../../../components/MaterialSymbol", () => ({
  default: ({ icon }) => <span data-testid={`icon-${icon}`} />,
}));

import MilestoneCard from "../../../pages/History/MilestoneCard";

function makeMilestone(overrides = {}) {
  return {
    id: 1,
    moment: "2024-03-05",
    title: "Marco de teste",
    body: "Corpo do marco",
    category: null,
    image: null,
    media: [],
    has_drive_gallery: false,
    external_url: null,
    external_label: null,
    ...overrides,
  };
}

describe("MilestoneCard", () => {
  it("renders title, date and body", () => {
    render(<MilestoneCard milestone={makeMilestone()} onOpenGallery={vi.fn()} />);

    expect(screen.getByText("Marco de teste")).toBeInTheDocument();
    expect(screen.getByText("5 de março de 2024")).toBeInTheDocument();
    expect(screen.getByText("Corpo do marco")).toBeInTheDocument();
  });

  it("sets an anchor id from the milestone id", () => {
    const { container } = render(
      <MilestoneCard milestone={makeMilestone({ id: 42 })} onOpenGallery={vi.fn()} />
    );
    expect(container.querySelector("#marco-42")).toBeInTheDocument();
  });

  it("renders the category chip when a category is set", () => {
    render(
      <MilestoneCard
        milestone={makeMilestone({
          category: { slug: "evento", label: "Evento", color: "hsl(210 90% 55%)" },
        })}
        onOpenGallery={vi.fn()}
      />
    );
    expect(screen.getByText("Evento")).toBeInTheDocument();
  });

  it("renders no category chip when category is null", () => {
    render(<MilestoneCard milestone={makeMilestone()} onOpenGallery={vi.fn()} />);
    expect(screen.queryByText("Fundação")).not.toBeInTheDocument();
  });

  it("shows no gallery button when there is no media and no drive folder", () => {
    render(<MilestoneCard milestone={makeMilestone()} onOpenGallery={vi.fn()} />);
    expect(screen.queryByRole("button", { name: /ver galeria/i })).not.toBeInTheDocument();
  });

  it("shows the gallery button when there is uploaded media", () => {
    render(
      <MilestoneCard
        milestone={makeMilestone({
          media: [{ id: 1, url: "a.jpg", thumb: "a-thumb.jpg", source: "upload" }],
        })}
        onOpenGallery={vi.fn()}
      />
    );
    expect(screen.getByRole("button", { name: /ver galeria/i })).toBeInTheDocument();
  });

  it("shows the gallery button when only a Drive folder is linked (no media rows yet)", () => {
    render(
      <MilestoneCard
        milestone={makeMilestone({ has_drive_gallery: true })}
        onOpenGallery={vi.fn()}
      />
    );
    expect(screen.getByRole("button", { name: /ver galeria/i })).toBeInTheDocument();
  });

  it("calls onOpenGallery with the milestone when the gallery button is clicked", async () => {
    const onOpenGallery = vi.fn();
    const user = userEvent.setup();
    const milestone = makeMilestone({ has_drive_gallery: true });

    render(<MilestoneCard milestone={milestone} onOpenGallery={onOpenGallery} />);
    await user.click(screen.getByRole("button", { name: /ver galeria/i }));

    expect(onOpenGallery).toHaveBeenCalledWith(milestone);
  });

  it("renders the external link with its custom label", () => {
    render(
      <MilestoneCard
        milestone={makeMilestone({
          external_url: "https://example.com/noticia",
          external_label: "Ler notícia",
        })}
        onOpenGallery={vi.fn()}
      />
    );
    const link = screen.getByRole("link", { name: /ler notícia/i });
    expect(link).toHaveAttribute("href", "https://example.com/noticia");
    expect(link).toHaveAttribute("target", "_blank");
    expect(link).toHaveAttribute("rel", "noreferrer");
  });

  it("falls back to a default external link label", () => {
    render(
      <MilestoneCard
        milestone={makeMilestone({ external_url: "https://example.com" })}
        onOpenGallery={vi.fn()}
      />
    );
    expect(screen.getByRole("link", { name: /saber mais/i })).toBeInTheDocument();
  });

  it("prefers the cover image over the first media thumbnail", () => {
    const { container } = render(
      <MilestoneCard
        milestone={makeMilestone({
          image: "cover.jpg",
          media: [{ id: 1, url: "a.jpg", thumb: "a-thumb.jpg", source: "upload" }],
        })}
        onOpenGallery={vi.fn()}
      />
    );
    expect(container.querySelector("img")).toHaveAttribute("src", "cover.jpg");
  });

  it("falls back to the first media thumbnail when there is no cover image", () => {
    const { container } = render(
      <MilestoneCard
        milestone={makeMilestone({
          media: [{ id: 1, url: "a.jpg", thumb: "a-thumb.jpg", source: "upload" }],
        })}
        onOpenGallery={vi.fn()}
      />
    );
    expect(container.querySelector("img")).toHaveAttribute("src", "a-thumb.jpg");
  });

  it("renders no cover image element when there is none available", () => {
    const { container } = render(
      <MilestoneCard milestone={makeMilestone()} onOpenGallery={vi.fn()} />
    );
    expect(container.querySelector("img")).not.toBeInTheDocument();
  });
});

import React from "react";
import { describe, it, expect, vi } from "vitest";
import { render, screen } from "@testing-library/react";

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

import FeaturedMilestone from "../../../pages/History/FeaturedMilestone";

function makeMilestone(overrides = {}) {
  return {
    id: 1,
    moment: "2023-11-05",
    title: "30º aniversário",
    body: "Celebração",
    category: { slug: "fundacao", label: "Fundação", color: "hsl(145 80% 35%)" },
    image: null,
    media: [],
    has_drive_gallery: false,
    external_url: null,
    external_label: null,
    ...overrides,
  };
}

describe("FeaturedMilestone", () => {
  // Regression: the "Em destaque" badge used to be absolutely positioned
  // over the cover unconditionally, so a featured milestone with no cover
  // image rendered the badge floating on top of the date/category row.
  it("renders the badge inline (not as a cover overlay) when there is no cover image", () => {
    const { container } = render(
      <FeaturedMilestone milestone={makeMilestone()} onOpenGallery={vi.fn()} />
    );

    const badge = screen.getByText("Em destaque").closest("span");
    expect(badge).not.toHaveClass("history-featured__badge--overlay");
    expect(container.querySelector(".history-featured__cover")).not.toBeInTheDocument();
  });

  it("renders the badge as a cover overlay when a cover image is present", () => {
    const { container } = render(
      <FeaturedMilestone
        milestone={makeMilestone({ image: "cover.jpg" })}
        onOpenGallery={vi.fn()}
      />
    );

    const badge = screen.getByText("Em destaque").closest("span");
    expect(badge).toHaveClass("history-featured__badge--overlay");
    expect(container.querySelector(".history-featured__cover img")).toHaveAttribute(
      "src",
      "cover.jpg"
    );
  });

  it("renders exactly one badge regardless of cover state", () => {
    render(<FeaturedMilestone milestone={makeMilestone({ image: "cover.jpg" })} onOpenGallery={vi.fn()} />);
    expect(screen.getAllByText("Em destaque")).toHaveLength(1);
  });

  it("renders title and category", () => {
    render(<FeaturedMilestone milestone={makeMilestone()} onOpenGallery={vi.fn()} />);
    expect(screen.getByText("30º aniversário")).toBeInTheDocument();
    expect(screen.getByText("Fundação")).toBeInTheDocument();
  });

  it("sets an anchor id from the milestone id", () => {
    const { container } = render(
      <FeaturedMilestone milestone={makeMilestone({ id: 7 })} onOpenGallery={vi.fn()} />
    );
    expect(container.querySelector("#marco-7")).toBeInTheDocument();
  });
});

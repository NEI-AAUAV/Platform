import React from "react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

vi.mock("../../../services/NEIService", () => ({
  default: { getHistoryGallery: vi.fn() },
}));

vi.mock("../../../components/MaterialSymbol", () => ({
  default: ({ icon }) => <span data-testid={`icon-${icon}`} />,
}));

import service from "../../../services/NEIService";
import GalleryLightbox from "../../../pages/History/GalleryLightbox";

const uploadMedia = [
  { id: 1, url: "a.jpg", thumb: "a-thumb.jpg", caption: "Foto A", source: "upload" },
  { id: 2, url: "b.jpg", thumb: "b-thumb.jpg", caption: "Foto B", source: "upload" },
];

function makeMilestone(overrides = {}) {
  return {
    id: 11,
    title: "Fundação do NEI",
    media: uploadMedia,
    has_drive_gallery: false,
    ...overrides,
  };
}

describe("GalleryLightbox", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("renders nothing when there is no milestone", () => {
    render(<GalleryLightbox milestone={null} onClose={vi.fn()} />);
    expect(screen.queryByRole("dialog")).not.toBeInTheDocument();
  });

  it("shows the milestone's own media without calling the API when there is no Drive folder", async () => {
    render(<GalleryLightbox milestone={makeMilestone()} onClose={vi.fn()} />);

    expect(await screen.findByAltText("Foto A")).toHaveAttribute("src", "a.jpg");
    expect(screen.getByText("Foto A")).toBeInTheDocument();
    expect(screen.getByText("1 / 2")).toBeInTheDocument();
    expect(service.getHistoryGallery).not.toHaveBeenCalled();
  });

  it("fetches and merges Drive-folder photos when has_drive_gallery is true", async () => {
    service.getHistoryGallery.mockResolvedValue({
      id: 11,
      title: "Fundação do NEI",
      media: [
        ...uploadMedia,
        { id: 3, url: "c.jpg", thumb: "c-thumb.jpg", caption: "Foto C", source: "drive" },
      ],
    });

    render(
      <GalleryLightbox
        milestone={makeMilestone({ has_drive_gallery: true })}
        onClose={vi.fn()}
      />
    );

    expect(service.getHistoryGallery).toHaveBeenCalledWith(11);
    await waitFor(() => expect(screen.getByText("1 / 3")).toBeInTheDocument());
  });

  it("shows a loading message while the Drive gallery is being fetched", async () => {
    let resolveFetch;
    service.getHistoryGallery.mockReturnValue(
      new Promise((resolve) => {
        resolveFetch = resolve;
      })
    );

    render(
      <GalleryLightbox
        milestone={makeMilestone({ media: [], has_drive_gallery: true })}
        onClose={vi.fn()}
      />
    );

    expect(screen.getByText("A carregar fotos…")).toBeInTheDocument();
    resolveFetch({ id: 11, title: "x", media: [] });
    await waitFor(() =>
      expect(screen.queryByText("A carregar fotos…")).not.toBeInTheDocument()
    );
  });

  it("shows a fallback message when a milestone has no photos at all", () => {
    render(<GalleryLightbox milestone={makeMilestone({ media: [] })} onClose={vi.fn()} />);
    expect(
      screen.getByText("Sem fotos disponíveis para este marco.")
    ).toBeInTheDocument();
  });

  it("keeps the milestone's own media when the Drive fetch fails", async () => {
    service.getHistoryGallery.mockRejectedValue(new Error("network down"));

    render(
      <GalleryLightbox
        milestone={makeMilestone({ has_drive_gallery: true })}
        onClose={vi.fn()}
      />
    );

    await waitFor(() => expect(screen.getByText("1 / 2")).toBeInTheDocument());
  });

  it("navigates to the next photo with the arrow button and wraps around", async () => {
    const user = userEvent.setup();
    render(<GalleryLightbox milestone={makeMilestone()} onClose={vi.fn()} />);

    await screen.findByText("1 / 2");
    await user.click(screen.getByLabelText("Foto seguinte"));
    expect(screen.getByText("2 / 2")).toBeInTheDocument();

    await user.click(screen.getByLabelText("Foto seguinte"));
    expect(screen.getByText("1 / 2")).toBeInTheDocument();
  });

  it("navigates to the previous photo, wrapping to the last one", async () => {
    const user = userEvent.setup();
    render(<GalleryLightbox milestone={makeMilestone()} onClose={vi.fn()} />);

    await screen.findByText("1 / 2");
    await user.click(screen.getByLabelText("Foto anterior"));
    expect(screen.getByText("2 / 2")).toBeInTheDocument();
  });

  it("does not render navigation controls for a single-photo gallery", async () => {
    render(
      <GalleryLightbox
        milestone={makeMilestone({ media: [uploadMedia[0]] })}
        onClose={vi.fn()}
      />
    );

    await screen.findByAltText("Foto A");
    expect(screen.queryByLabelText("Foto seguinte")).not.toBeInTheDocument();
    expect(screen.queryByLabelText("Foto anterior")).not.toBeInTheDocument();
  });

  it("resets to the first photo when switching to a different milestone", async () => {
    const user = userEvent.setup();
    const { rerender } = render(
      <GalleryLightbox milestone={makeMilestone()} onClose={vi.fn()} />
    );

    await screen.findByText("1 / 2");
    await user.click(screen.getByLabelText("Foto seguinte"));
    expect(screen.getByText("2 / 2")).toBeInTheDocument();

    rerender(
      <GalleryLightbox
        milestone={makeMilestone({ id: 12, title: "Outro marco" })}
        onClose={vi.fn()}
      />
    );

    expect(await screen.findByText("1 / 2")).toBeInTheDocument();
  });

  it("calls onClose when the dialog is dismissed", async () => {
    const onClose = vi.fn();
    const user = userEvent.setup();
    render(<GalleryLightbox milestone={makeMilestone()} onClose={onClose} />);

    await screen.findByText("1 / 2");
    await user.keyboard("{Escape}");
    expect(onClose).toHaveBeenCalled();
  });
});

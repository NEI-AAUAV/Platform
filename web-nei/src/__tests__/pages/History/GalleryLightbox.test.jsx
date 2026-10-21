import React from "react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import { act, fireEvent, render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

vi.mock("../../../services/NEIService", () => ({
  default: { getHistoryGallery: vi.fn() },
}));

vi.mock("../../../components/MaterialSymbol", () => ({
  default: ({ icon }) => <span data-testid={`icon-${icon}`} />,
}));

import service from "../../../services/NEIService";
import GalleryLightbox from "../../../pages/History/GalleryLightbox";

const PHOTOS = [
  { id: "upload:1", url: "a.jpg", thumb: "a-thumb.jpg", caption: "Foto A", source: "upload" },
  { id: "upload:2", url: "b.jpg", thumb: "b-thumb.jpg", caption: "Foto B", source: "upload" },
];

function makeMilestone(overrides = {}) {
  return { id: 11, title: "Fundação do NEI", has_drive_gallery: false, ...overrides };
}

function gallery(media = PHOTOS, extra = {}) {
  return { id: 11, title: "x", media, drive_status: null, truncated: false, ...extra };
}

/** A gallery request the test answers (or fails) by hand, recording the
 * AbortSignal it was given. */
function deferred() {
  const request = {};
  request.promise = new Promise((resolve, reject) => {
    request.resolve = resolve;
    request.reject = reject;
  });
  return request;
}

function queueRequests(...requests) {
  const signals = [];
  let n = 0;
  service.getHistoryGallery.mockImplementation((_id, { signal } = {}) => {
    signals.push(signal);
    return requests[n++].promise;
  });
  return signals;
}

function renderLightbox(props = {}) {
  return render(
    <GalleryLightbox milestone={makeMilestone()} onClose={vi.fn()} {...props} />
  );
}

function touch(element, type, x, y) {
  fireEvent[type](element, {
    touches: type === "touchEnd" ? [] : [{ clientX: x, clientY: y }],
    changedTouches: [{ clientX: x, clientY: y }],
  });
}

function swipe(element, from, to) {
  touch(element, "touchStart", ...from);
  touch(element, "touchEnd", ...to);
}

describe("GalleryLightbox", () => {
  beforeEach(() => {
    vi.clearAllMocks();
    service.getHistoryGallery.mockResolvedValue(gallery());
  });

  it("renders nothing and requests nothing when there is no milestone", () => {
    render(<GalleryLightbox milestone={null} onClose={vi.fn()} />);
    expect(screen.queryByRole("dialog")).not.toBeInTheDocument();
    expect(service.getHistoryGallery).not.toHaveBeenCalled();
  });

  it("loads the gallery from the API and shows the first photo", async () => {
    renderLightbox();

    expect(screen.getByText("A carregar fotos…")).toBeInTheDocument();
    expect(await screen.findByAltText("Foto A")).toHaveAttribute("src", "a.jpg");
    expect(screen.getByText("1 / 2")).toBeInTheDocument();
    expect(service.getHistoryGallery).toHaveBeenCalledWith(11, {
      signal: expect.any(AbortSignal),
    });
  });

  it("says when a gallery has no photos", async () => {
    service.getHistoryGallery.mockResolvedValue(gallery([]));
    renderLightbox();

    expect(await screen.findByText("Sem fotos disponíveis para este marco.")).toBeInTheDocument();
  });

  it("offers a retry when the request fails", async () => {
    service.getHistoryGallery
      .mockRejectedValueOnce(new Error("timeout"))
      .mockResolvedValueOnce(gallery());
    const user = userEvent.setup();
    renderLightbox();

    expect(await screen.findByText("Não foi possível carregar a galeria.")).toBeInTheDocument();
    await user.click(screen.getByRole("button", { name: /tentar de novo/i }));
    expect(await screen.findByText("1 / 2")).toBeInTheDocument();
    expect(service.getHistoryGallery).toHaveBeenCalledTimes(2);
  });

  it("says when Drive failed but still shows the photos it has", async () => {
    service.getHistoryGallery.mockResolvedValue(gallery(PHOTOS, { drive_status: "error" }));
    renderLightbox({ milestone: makeMilestone({ has_drive_gallery: true }) });

    expect(await screen.findByText("1 / 2")).toBeInTheDocument();
    expect(screen.getByText("Algumas fotos não puderam ser carregadas agora.")).toBeInTheDocument();
  });

  it("shows a transient-error message without a misleading retry when Drive failed and there is nothing else to show", async () => {
    // The backend caches a Drive error for 60s (google_drive.py _TTL_ERROR_SECONDS),
    // so an immediate retry would just replay the same cached failure. No retry
    // button should be offered here — see api-nei/app/integrations/google_drive.py.
    service.getHistoryGallery.mockResolvedValue(gallery([], { drive_status: "error" }));
    renderLightbox({ milestone: makeMilestone({ has_drive_gallery: true }) });

    expect(
      await screen.findByText(
        "As fotos deste marco não puderam ser carregadas agora. Tente novamente dentro de momentos."
      )
    ).toBeInTheDocument();
    expect(screen.queryByRole("button", { name: /tentar de novo/i })).not.toBeInTheDocument();
  });

  it.each(["unavailable", "disabled"])(
    "calls an empty %s folder unavailable, without technical detail",
    async (driveStatus) => {
      service.getHistoryGallery.mockResolvedValue(gallery([], { drive_status: driveStatus }));
      renderLightbox({ milestone: makeMilestone({ has_drive_gallery: true }) });

      expect(
        await screen.findByText("A galeria deste marco não está disponível de momento.")
      ).toBeInTheDocument();
      expect(screen.queryByRole("button", { name: /tentar de novo/i })).not.toBeInTheDocument();
      expect(screen.queryByText(/drive|api|403/i)).not.toBeInTheDocument();
    }
  );

  it("notes missing folder photos next to the milestone's own", async () => {
    service.getHistoryGallery.mockResolvedValue(gallery(PHOTOS, { drive_status: "unavailable" }));
    renderLightbox({ milestone: makeMilestone({ has_drive_gallery: true }) });

    expect(await screen.findByText("1 / 2")).toBeInTheDocument();
    expect(
      screen.getByText("Algumas fotos desta galeria não estão disponíveis.")
    ).toBeInTheDocument();
  });

  it("shows no notice for a complete Drive gallery", async () => {
    service.getHistoryGallery.mockResolvedValue(gallery(PHOTOS, { drive_status: "ok" }));
    renderLightbox({ milestone: makeMilestone({ has_drive_gallery: true }) });

    expect(await screen.findByText("1 / 2")).toBeInTheDocument();
    expect(document.querySelector(".history-lightbox__notice")).toBeNull();
  });

  it("doesn't pretend a truncated gallery is complete", async () => {
    service.getHistoryGallery.mockResolvedValue(gallery(PHOTOS, { truncated: true }));
    renderLightbox();

    expect(await screen.findByText("A mostrar as primeiras 2 fotos desta galeria.")).toBeInTheDocument();
  });

  describe("switching galleries", () => {
    it("starts clean after closing a gallery that was still loading", async () => {
      const pending = deferred();
      const second = deferred();
      const signals = queueRequests(pending, second);
      const { rerender } = renderLightbox({ milestone: makeMilestone({ has_drive_gallery: true }) });
      expect(screen.getByText("A carregar fotos…")).toBeInTheDocument();

      rerender(<GalleryLightbox milestone={null} onClose={vi.fn()} />);
      expect(signals[0].aborted).toBe(true);

      rerender(<GalleryLightbox milestone={makeMilestone({ id: 12 })} onClose={vi.fn()} />);
      await act(async () => second.resolve(gallery([PHOTOS[1]])));

      expect(screen.getByAltText("Foto B")).toBeInTheDocument();
      expect(screen.queryByText("A carregar fotos…")).not.toBeInTheDocument();
    });

    it("ignores a late answer for the gallery the user already left", async () => {
      const first = deferred();
      const second = deferred();
      const signals = queueRequests(first, second);
      const { rerender } = renderLightbox();

      rerender(<GalleryLightbox milestone={makeMilestone({ id: 12 })} onClose={vi.fn()} />);
      expect(signals[0].aborted).toBe(true);

      await act(async () => second.resolve(gallery([PHOTOS[1]])));
      await act(async () => first.resolve(gallery([PHOTOS[0]])));

      expect(screen.getByAltText("Foto B")).toBeInTheDocument();
      expect(screen.queryByAltText("Foto A")).not.toBeInTheDocument();
    });

    it("never shows the previous gallery's photos while the next one loads", async () => {
      const next = deferred();
      service.getHistoryGallery
        .mockResolvedValueOnce(gallery())
        .mockImplementationOnce(() => next.promise);
      const { rerender } = renderLightbox();
      await screen.findByText("1 / 2");

      rerender(<GalleryLightbox milestone={makeMilestone({ id: 12 })} onClose={vi.fn()} />);
      expect(screen.queryByAltText("Foto A")).not.toBeInTheDocument();
      expect(screen.getByText("A carregar fotos…")).toBeInTheDocument();
    });

    it("resets to the first photo for a different milestone", async () => {
      const user = userEvent.setup();
      const { rerender } = renderLightbox();

      await screen.findByText("1 / 2");
      await user.click(screen.getByLabelText("Foto seguinte"));
      expect(screen.getByText("2 / 2")).toBeInTheDocument();

      rerender(<GalleryLightbox milestone={makeMilestone({ id: 12 })} onClose={vi.fn()} />);
      expect(await screen.findByText("1 / 2")).toBeInTheDocument();
    });
  });

  describe("navigation", () => {
    it("moves with the arrow buttons and wraps around", async () => {
      const user = userEvent.setup();
      renderLightbox();

      await screen.findByText("1 / 2");
      await user.click(screen.getByLabelText("Foto seguinte"));
      expect(screen.getByText("2 / 2")).toBeInTheDocument();
      await user.click(screen.getByLabelText("Foto seguinte"));
      expect(screen.getByText("1 / 2")).toBeInTheDocument();
      await user.click(screen.getByLabelText("Foto anterior"));
      expect(screen.getByText("2 / 2")).toBeInTheDocument();
    });

    it("moves with the keyboard arrows", async () => {
      const user = userEvent.setup();
      renderLightbox();

      await screen.findByText("1 / 2");
      await user.keyboard("{ArrowRight}");
      expect(screen.getByText("2 / 2")).toBeInTheDocument();
      await user.keyboard("{ArrowLeft}");
      expect(screen.getByText("1 / 2")).toBeInTheDocument();
    });

    it("has no navigation controls for a single photo", async () => {
      service.getHistoryGallery.mockResolvedValue(gallery([PHOTOS[0]]));
      renderLightbox();

      await screen.findByAltText("Foto A");
      expect(screen.queryByLabelText("Foto seguinte")).not.toBeInTheDocument();
    });

    it("jumps to a photo from the thumbnail strip", async () => {
      const user = userEvent.setup();
      renderLightbox();

      await user.click(await screen.findByRole("button", { name: "Foto 2" }));
      expect(screen.getByText("2 / 2")).toBeInTheDocument();
      expect(screen.getByRole("button", { name: "Foto 2" })).toHaveAttribute("aria-current", "true");
    });

    it("reports every photo change", async () => {
      const onIndexChange = vi.fn();
      const user = userEvent.setup();
      renderLightbox({ onIndexChange });

      await screen.findByText("1 / 2");
      await user.click(screen.getByLabelText("Foto seguinte"));
      expect(onIndexChange).toHaveBeenLastCalledWith(1);
    });

    it("calls onClose when dismissed", async () => {
      const onClose = vi.fn();
      const user = userEvent.setup();
      renderLightbox({ onClose });

      await screen.findByText("1 / 2");
      await user.keyboard("{Escape}");
      expect(onClose).toHaveBeenCalled();
    });
  });

  describe("deep links", () => {
    it("opens on the requested photo without rewriting it", async () => {
      const onIndexChange = vi.fn();
      renderLightbox({ initialIndex: 1, onIndexChange });

      expect(await screen.findByText("2 / 2")).toBeInTheDocument();
      expect(screen.getByAltText("Foto B")).toBeInTheDocument();
      expect(onIndexChange).not.toHaveBeenCalled();
    });

    it("falls back to the first photo and reports it, so the URL follows", async () => {
      const onIndexChange = vi.fn();
      renderLightbox({ initialIndex: 998, onIndexChange });

      expect(await screen.findByText("1 / 2")).toBeInTheDocument();
      expect(onIndexChange).toHaveBeenCalledWith(0);
    });
  });

  describe("swipe", () => {
    async function stage() {
      renderLightbox();
      await screen.findByText("1 / 2");
      return screen.getByAltText("Foto A").closest("figure");
    }

    it("goes to the next photo on a clear left swipe over the photo", async () => {
      swipe(await stage(), [300, 200], [150, 210]);
      expect(screen.getByText("2 / 2")).toBeInTheDocument();
    });

    it("goes back on a right swipe", async () => {
      swipe(await stage(), [100, 200], [260, 190]);
      expect(screen.getByText("2 / 2")).toBeInTheDocument();
    });

    it.each([
      ["vertical", [200, 100], [205, 400]],
      ["diagonal", [300, 100], [200, 220]],
      ["too short", [200, 200], [170, 200]],
    ])("ignores a %s drag", async (_kind, from, to) => {
      swipe(await stage(), from, to);
      expect(screen.getByText("1 / 2")).toBeInTheDocument();
    });

    it("leaves the thumbnail strip to scroll natively", async () => {
      renderLightbox();
      await screen.findByText("1 / 2");

      swipe(screen.getByRole("list"), [300, 20], [50, 20]);
      expect(screen.getByText("1 / 2")).toBeInTheDocument();
    });
  });

  it("shows a placeholder instead of a broken image", async () => {
    renderLightbox();

    fireEvent.error(await screen.findByAltText("Foto A"));
    expect(screen.getByRole("img", { name: "Foto indisponível" })).toBeInTheDocument();
    expect(screen.getByText("1 / 2")).toBeInTheDocument();
  });

  it("labels an uncaptioned photo by position rather than inventing a description", async () => {
    service.getHistoryGallery.mockResolvedValue(
      gallery([{ id: "drive:x", url: "x.jpg", thumb: "x-t.jpg", source: "drive" }])
    );
    renderLightbox();

    expect(await screen.findByAltText("Foto 1 de 1")).toBeInTheDocument();
  });

  it("sizes the photo from its known dimensions", async () => {
    service.getHistoryGallery.mockResolvedValue(
      gallery([{ id: "drive:x", url: "x.jpg", thumb: "x-t.jpg", caption: "X", source: "drive", width: 800, height: 600 }])
    );
    renderLightbox();

    const image = await screen.findByAltText("X");
    expect(image).toHaveAttribute("width", "800");
    expect(image).toHaveAttribute("height", "600");
  });

  it("still has the gallery settled after a late failure of an aborted request", async () => {
    const first = deferred();
    const second = deferred();
    queueRequests(first, second);
    const { rerender } = renderLightbox();

    rerender(<GalleryLightbox milestone={makeMilestone({ id: 12 })} onClose={vi.fn()} />);
    await act(async () => second.resolve(gallery()));
    await act(async () => first.reject(new Error("aborted")));

    expect(await screen.findByText("1 / 2")).toBeInTheDocument();
    expect(screen.queryByText("Não foi possível carregar a galeria.")).not.toBeInTheDocument();
  });
});

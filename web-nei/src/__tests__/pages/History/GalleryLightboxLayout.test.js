import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { describe, it, expect } from "vitest";

/* jsdom does no layout, so the short-viewport guarantees are checked on the
   stylesheet itself: without them a landscape phone (e.g. 667x375) pushes
   the close button and thumbnails outside the centred dialog. */
const css = readFileSync(
  resolve(__dirname, "../../../pages/History/GalleryLightbox.css"),
  "utf8"
);

function block(selector, source = css) {
  const start = source.indexOf(`${selector} {`);
  expect(start, `${selector} rule`).toBeGreaterThanOrEqual(0);
  return source.slice(start, source.indexOf("}", start));
}

describe("GalleryLightbox layout", () => {
  it("caps the dialog to the visible viewport and scrolls inside it", () => {
    const dialog = block(".history-lightbox");
    expect(dialog).toMatch(/max-height:\s*calc\(100dvh - /);
    expect(dialog).toMatch(/max-height:\s*calc\(100vh - /); // no-dvh fallback
    expect(dialog).toMatch(/overflow-y:\s*auto/);
  });

  it("sizes the photo from the viewport height, not a fixed share of it", () => {
    expect(block(".history-lightbox__image")).toMatch(/max-height:\s*min\(70vh, calc\(100dvh - /);
  });

  it("tightens the layout on short viewports without hiding caption or thumbnails", () => {
    const start = css.indexOf("@media (max-height: 500px)");
    expect(start).toBeGreaterThanOrEqual(0);
    const short = css.slice(start);
    expect(block(".history-lightbox__image", short)).toMatch(/max-height:\s*calc\(100dvh - /);
    expect(short).not.toMatch(/display:\s*none/);
  });
});

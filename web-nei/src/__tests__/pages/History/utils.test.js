import { describe, it, expect } from "vitest";
import {
  academicYear,
  groupByMandate,
  mandateAnchorId,
  formatMilestoneDate,
  galleryCount,
  hasGallery,
  milestoneCover,
  mandateLabel,
  usedCategories,
} from "../../../pages/History/utils";

describe("academicYear", () => {
  it("assigns a September date to the year that just started", () => {
    expect(academicYear("2025-09-15")).toBe("2025/26");
  });

  it("assigns an August date to the previous academic year", () => {
    expect(academicYear("2026-08-31")).toBe("2025/26");
  });

  it("assigns a January date to the academic year that started the previous calendar year", () => {
    expect(academicYear("2026-01-10")).toBe("2025/26");
  });

  it("pads the end year with a leading zero", () => {
    expect(academicYear("2009-10-01")).toBe("2009/10");
  });
});

describe("groupByMandate", () => {
  it("groups milestones by mandate, newest mandate first, keeping input order", () => {
    const milestones = [
      { id: 1, moment: "2025-03-01", mandate: null }, // 2024/25
      { id: 2, moment: "2025-10-01", mandate: null }, // 2025/26
      { id: 3, moment: "2024-11-01", mandate: null }, // 2024/25
    ];

    const groups = groupByMandate(milestones);

    expect(groups.map((g) => g.mandate)).toEqual(["2025/26", "2024/25"]);
    expect(groups[1].items.map((m) => m.id)).toEqual([1, 3]);
  });

  it("honours an explicit editorial mandate over the date", () => {
    const groups = groupByMandate([{ id: 1, moment: "2025-10-01", mandate: "2023/24" }]);
    expect(groups[0].mandate).toBe("2023/24");
  });

  it("returns an empty array for no milestones", () => {
    expect(groupByMandate([])).toEqual([]);
  });
});

describe("mandateAnchorId", () => {
  it("builds a URL-safe anchor id", () => {
    expect(mandateAnchorId("2025/26")).toBe("history-mandato-2025-26");
  });
});

describe("galleryCount / hasGallery", () => {
  const base = { media: [], has_drive_gallery: false };

  it("uses the API count when present", () => {
    expect(galleryCount({ ...base, has_drive_gallery: true, gallery_count: 12 })).toBe(12);
  });

  it("is unknown (null) for an unresolved Drive folder, and still offers the gallery", () => {
    const milestone = { ...base, has_drive_gallery: true, gallery_count: null };
    expect(galleryCount(milestone)).toBeNull();
    expect(hasGallery(milestone)).toBe(true);
  });

  it("hides the gallery for a Drive folder known to be empty", () => {
    expect(hasGallery({ ...base, has_drive_gallery: true, gallery_count: 0 })).toBe(false);
  });

  it("falls back to the own media count without a Drive folder", () => {
    expect(galleryCount({ ...base, media: [{ id: "upload:1" }] })).toBe(1);
    expect(hasGallery(base)).toBe(false);
  });
});

describe("milestoneCover", () => {
  it("prefers the API cover", () => {
    expect(milestoneCover({ cover: "c.jpg", image: "i.jpg", media: [] })).toBe("c.jpg");
  });

  it("falls back to image, then first media thumbnail, then null", () => {
    expect(milestoneCover({ image: "i.jpg", media: [] })).toBe("i.jpg");
    expect(milestoneCover({ image: null, media: [{ thumb: "t.jpg" }] })).toBe("t.jpg");
    expect(milestoneCover({ image: null, media: [] })).toBeNull();
  });
});

describe("formatMilestoneDate", () => {
  it("formats a date in long pt-PT form", () => {
    expect(formatMilestoneDate("2024-03-05")).toBe("5 de março de 2024");
  });
});

describe("mandateLabel", () => {
  it("prefers the explicit mandate field when set", () => {
    expect(mandateLabel({ mandate: "2020/21", moment: "2024-01-01" })).toBe(
      "2020/21"
    );
  });

  it("derives the mandate from the date when unset", () => {
    expect(mandateLabel({ mandate: null, moment: "2024-10-01" })).toBe(
      "2024/25"
    );
  });
});

describe("usedCategories", () => {
  it("dedupes categories across milestones, sorted by label", () => {
    const milestones = [
      { category: { slug: "evento", label: "Evento", color: "blue" } },
      { category: { slug: "fundacao", label: "Fundação", color: "green" } },
      { category: { slug: "evento", label: "Evento", color: "blue" } },
      { category: null },
    ];

    expect(usedCategories(milestones)).toEqual([
      { slug: "evento", label: "Evento", color: "blue" },
      { slug: "fundacao", label: "Fundação", color: "green" },
    ]);
  });

  it("orders categories by their CMS weight before the label", () => {
    const milestones = [
      { category: { slug: "a", label: "Alfa", weight: 2 } },
      { category: { slug: "z", label: "Zulu", weight: 1 } },
    ];
    expect(usedCategories(milestones).map((c) => c.slug)).toEqual(["z", "a"]);
  });

  it("returns an empty array when no milestone has a category", () => {
    expect(usedCategories([{ category: null }])).toEqual([]);
  });
});

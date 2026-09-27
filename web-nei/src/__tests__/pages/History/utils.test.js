import { afterEach, describe, it, expect, vi } from "vitest";
import {
  academicYear,
  groupByMandate,
  mandateAnchorId,
  formatMilestoneDate,
  galleryCount,
  hasGallery,
  isCategorySlug,
  milestoneCover,
  parsePhotoParam,
  safeCssColor,
  categoryStyle,
  scrollBehavior,
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
  const base = { has_drive_gallery: false, gallery_count: 0 };

  it("uses the API count of the milestone's own photos", () => {
    expect(galleryCount({ ...base, gallery_count: 3 })).toBe(3);
    expect(hasGallery({ ...base, gallery_count: 3 })).toBe(true);
  });

  it("is unknown (null) with a Drive folder, and still offers the gallery", () => {
    const milestone = { ...base, has_drive_gallery: true, gallery_count: null };
    expect(galleryCount(milestone)).toBeNull();
    expect(hasGallery(milestone)).toBe(true);
  });

  it("hides the gallery without photos or a Drive folder", () => {
    expect(hasGallery(base)).toBe(false);
    expect(hasGallery({ has_drive_gallery: false })).toBe(false);
  });
});

describe("milestoneCover", () => {
  it("prefers the API cover, then image, then null", () => {
    expect(milestoneCover({ cover: "c.jpg", image: "i.jpg" })).toBe("c.jpg");
    expect(milestoneCover({ cover: null, image: "i.jpg" })).toBe("i.jpg");
    expect(milestoneCover({ cover: null, image: null })).toBeNull();
  });
});

describe("isCategorySlug", () => {
  it.each(["evento", "vida-academica", "a1"])("accepts %s", (slug) => {
    expect(isCategorySlug(slug)).toBe(true);
  });

  it.each(["Evento", "com espaço", "ação", "", "a_b", "<script>"])("rejects %j", (slug) => {
    expect(isCategorySlug(slug)).toBe(false);
  });
});

describe("safeCssColor / categoryStyle", () => {
  it.each(["#fff", "#1a2b3c", "#1a2b3c80", "hsl(210 90% 55%)", "rgb(10, 20, 30)", "hsla(1,2%,3%,.5)"])(
    "keeps the colour %s",
    (color) => {
      expect(safeCssColor(color)).toBe(color);
    }
  );

  it.each([
    "red; background: url(x)",
    "url(https://evil.example/x.png)",
    "var(--primary)",
    "expression(alert(1))",
    "",
    null,
  ])("drops %j", (color) => {
    expect(safeCssColor(color)).toBeNull();
  });

  it("only sets the chip colour for a usable value", () => {
    expect(categoryStyle({ color: "#123456" })).toEqual({ "--chip-color": "#123456" });
    expect(categoryStyle({ color: "nope" })).toBeUndefined();
    expect(categoryStyle(null)).toBeUndefined();
  });
});

describe("parsePhotoParam", () => {
  it("turns a 1-based photo number into a 0-based index", () => {
    expect(parsePhotoParam("1")).toBe(0);
    expect(parsePhotoParam("12")).toBe(11);
  });

  it.each([null, "0", "-1", "abc", "1.5", "01", ""])("is null for %j", (value) => {
    expect(parsePhotoParam(value)).toBeNull();
  });
});

describe("scrollBehavior", () => {
  afterEach(() => {
    vi.unstubAllGlobals();
  });

  it("scrolls instantly when the user prefers reduced motion", () => {
    vi.stubGlobal("matchMedia", (query) => ({ matches: query.includes("reduce") }));
    expect(scrollBehavior()).toBe("auto");
  });

  it("scrolls smoothly otherwise", () => {
    vi.stubGlobal("matchMedia", () => ({ matches: false }));
    expect(scrollBehavior()).toBe("smooth");
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

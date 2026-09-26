import { describe, it, expect } from "vitest";
import {
  academicYear,
  groupByYear,
  formatMilestoneDate,
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

describe("groupByYear", () => {
  it("groups milestones by calendar year, newest year first", () => {
    const milestones = [
      { id: 1, moment: "2022-01-01" },
      { id: 2, moment: "2024-06-01" },
      { id: 3, moment: "2022-12-01" },
    ];

    const groups = groupByYear(milestones);

    expect(groups.map((g) => g.year)).toEqual([2024, 2022]);
    expect(groups[1].items.map((m) => m.id)).toEqual([1, 3]);
  });

  it("returns an empty array for no milestones", () => {
    expect(groupByYear([])).toEqual([]);
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

  it("returns an empty array when no milestone has a category", () => {
    expect(usedCategories([{ category: null }])).toEqual([]);
  });
});

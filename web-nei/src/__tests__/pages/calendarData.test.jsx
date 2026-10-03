import { describe, it, expect } from "vitest";

import { locales } from "../../pages/Calendar/NEICalendar/data";
import calendarData, { categories } from "../../pages/Calendar/data";

describe("calendar locales", () => {
  it("has consistent pt lists", () => {
    const { days, daysShort, daysMin, months, monthsShort } = locales.pt;
    expect(days).toHaveLength(7);
    expect(daysShort).toHaveLength(7);
    expect(daysMin).toHaveLength(7);
    expect(months).toHaveLength(12);
    expect(monthsShort).toHaveLength(12);
    expect(months[0]).toBe("Janeiro");
  });
});

describe("calendar categories", () => {
  it("exposes categories as default export too", () => {
    expect(calendarData.categories).toBe(categories);
  });

  it("gives every category a name and color, and NEI has no prefixes", () => {
    for (const c of Object.values(categories)) {
      expect(c.name).toBeTruthy();
      expect(c.color).toMatch(/^\d+ \d+% \d+%$/);
    }
    expect(categories.NEI.prefixes).toBeUndefined();
  });
});

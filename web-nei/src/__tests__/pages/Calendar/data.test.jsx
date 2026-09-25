import { describe, it, expect } from "vitest";
import { categories } from "../../../pages/Calendar/data";

describe("Calendar/data categories", () => {
  it("exposes the expected category keys", () => {
    expect(Object.keys(categories)).toEqual([
      "1A",
      "2A",
      "3A",
      "MEI",
      "TacaUA",
      "CalendarioEscolar",
      "MDJD",
      "NEI",
    ]);
  });

  it("defines a name and color for every category", () => {
    Object.values(categories).forEach((category) => {
      expect(category).toHaveProperty("name");
      expect(category).toHaveProperty("color");
    });
  });

  it("defines the MDJD category with its expected prefix", () => {
    expect(categories.MDJD).toEqual({
      prefixes: ["[MDJD]"],
      name: "MDJD",
      color: "270 70% 45%",
    });
  });
});

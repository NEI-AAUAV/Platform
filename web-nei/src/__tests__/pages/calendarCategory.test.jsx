import { describe, it, expect } from "vitest";

import { getCategory } from "../../pages/Calendar/NEICalendar/utils";
import { categories } from "../../pages/Calendar/data";

const categoryKey = (title) => getCategory(title, categories)?.key ?? null;

describe("getCategory", () => {
  it("matches year and course prefixes", () => {
    expect(categoryKey("[1A] 1.º Teste FP")).toBe("1A");
    expect(categoryKey("[3A] Entrega Guião 1 CD")).toBe("3A");
    expect(categoryKey("[Taça UA] Futsal")).toBe("TacaUA");
  });

  it("matches school calendar keywords", () => {
    expect(categoryKey("Férias da Páscoa")).toBe("CalendarioEscolar");
  });

  it("matches NEI-only events", () => {
    expect(categoryKey("[NEI] Crashcourses")).toBe("NEI");
    expect(categoryKey("[NEI]Sessao de cinema")).toBe("NEI");
  });

  it("matches NEI events organized with other entities", () => {
    expect(categoryKey("[NEI/NEECT] Palestra Docker")).toBe("NEI");
    expect(categoryKey("[NEECT,NEI] - Convívio Magusto")).toBe("NEI");
    expect(categoryKey("[NEI, NEECT, NEEETA] Arraial do DETI")).toBe("NEI");
    expect(categoryKey("[NEECT/NEEETA/NEI] Convívio")).toBe("NEI");
    expect(categoryKey(" [NEI/NEEETA/NEECT/AETTUA] Palestra")).toBe("NEI");
  });

  it("does not match entities that only contain NEI as a substring", () => {
    expect(categoryKey("[NEIX] Evento")).toBeNull();
  });

  it("has no category for events of other entities only", () => {
    expect(categoryKey("[GLUA] Linux Install Party")).toBeNull();
    expect(categoryKey("[NEECT E NEEETA] Convívio")).toBeNull();
  });

  it("defaults to NEI for events without an entity", () => {
    expect(categoryKey("Feira do DETI")).toBe("NEI");
    expect(categoryKey("")).toBe("NEI");
  });
});

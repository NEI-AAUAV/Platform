import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";

const svc = vi.hoisted(() => ({ getExtensionsManifest: vi.fn() }));
vi.mock("../../services/NEIService", () => ({ default: svc }));

import {
  normalizeLink,
  checkDynamicVisibility,
  loadExtensionNavItems,
} from "../../layouts/Navbar/extensionNav";

const entry = (over = {}) => ({ label: "Gala", href: "/gala", ...over });

beforeEach(() => {
  svc.getExtensionsManifest.mockReset();
  vi.spyOn(console, "warn").mockImplementation(() => {});
});

afterEach(() => {
  vi.restoreAllMocks();
  vi.unstubAllGlobals();
  vi.useRealTimers();
});

describe("normalizeLink", () => {
  it("reduces absolute URLs to their path", () => {
    expect(normalizeLink("https://nei.pt/gala/events?x=1")).toBe("/gala/events");
    expect(normalizeLink("http://localhost")).toBe("/");
  });

  it("keeps relative links untouched", () => {
    expect(normalizeLink("/gala")).toBe("/gala");
  });

  it.each([undefined, null, "", 5])("passes through %j", (value) => {
    expect(normalizeLink(value)).toBe(value);
  });
});

describe("checkDynamicVisibility", () => {
  const dyn = (over = {}) =>
    entry({
      dynamicVisibility: {
        endpoint: "/api/status",
        field: "open",
        value: true,
        fallbackScopes: ["manager-gala"],
        ...over,
      },
    });

  it("returns items without dynamic visibility as they are", async () => {
    const item = entry();

    expect(await checkDynamicVisibility(item, [])).toBe(item);
  });

  it("shows the item when the endpoint reports the expected value", async () => {
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue({ ok: true, json: async () => ({ open: true }) }));

    expect(await checkDynamicVisibility(dyn(), [])).toEqual({ label: "Gala", href: "/gala" });
  });

  it("hides the item when the value differs and the user lacks a fallback scope", async () => {
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue({ ok: true, json: async () => ({ open: false }) }));

    expect(await checkDynamicVisibility(dyn(), ["other"])).toBeNull();
  });

  it("shows the item to users with a fallback scope even when the value differs", async () => {
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue({ ok: true, json: async () => ({ open: false }) }));

    expect(await checkDynamicVisibility(dyn(), ["manager-gala"])).toEqual({
      label: "Gala",
      href: "/gala",
    });
  });

  it("falls back to scopes on non-2xx responses", async () => {
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue({ ok: false, status: 503 }));

    expect(await checkDynamicVisibility(dyn(), [])).toBeNull();
    expect(await checkDynamicVisibility(dyn(), ["manager-gala"])).not.toBeNull();
  });

  it("falls back to scopes when the request fails", async () => {
    vi.stubGlobal("fetch", vi.fn().mockRejectedValue(new Error("offline")));

    expect(await checkDynamicVisibility(dyn(), [])).toBeNull();
  });

  it("treats a missing fallbackScopes list as no fallback", async () => {
    vi.stubGlobal("fetch", vi.fn().mockRejectedValue(new Error("offline")));

    expect(await checkDynamicVisibility(dyn({ fallbackScopes: undefined }), ["x"])).toBeNull();
  });

  it("aborts a slow check after 3 seconds", async () => {
    vi.useFakeTimers();
    vi.stubGlobal(
      "fetch",
      vi.fn(
        (_url, { signal }) =>
          new Promise((_, reject) =>
            signal.addEventListener("abort", () =>
              reject(Object.assign(new Error("aborted"), { name: "AbortError" }))
            )
          )
      )
    );

    const pending = checkDynamicVisibility(dyn(), []);
    await vi.advanceTimersByTimeAsync(3000);

    expect(await pending).toBeNull();
    expect(console.warn).toHaveBeenCalledWith(expect.stringContaining("timed out"));
  });
});

describe("loadExtensionNavItems", () => {
  it("returns visible entries for the user's scopes", async () => {
    svc.getExtensionsManifest.mockResolvedValue({
      nav: [
        entry({ label: "Public", href: "/public" }),
        entry({ label: "Managers", href: "/m", requiresScopes: ["manager-gala"] }),
        entry({ label: "Admins", href: "/a", requiresScopes: ["admin"] }),
      ],
    });

    const items = await loadExtensionNavItems(["manager-gala"], []);

    expect(items.map((i) => i.label)).toEqual(["Public", "Managers"]);
    expect(items[0]).toMatchObject({ label: "Public", href: "/public", key: "/public", branded: false });
  });

  it("any one of several required scopes is enough", async () => {
    svc.getExtensionsManifest.mockResolvedValue({
      nav: [entry({ requiresScopes: ["a", "b"] })],
    });

    expect(await loadExtensionNavItems(["b"], [])).toHaveLength(1);
    expect(await loadExtensionNavItems(["c"], [])).toHaveLength(0);
  });

  it("drops entries whose link already exists in the main navigation (also inside dropdowns)", async () => {
    svc.getExtensionsManifest.mockResolvedValue({
      nav: [
        entry({ label: "Dup", href: "https://nei.pt/events" }),
        entry({ label: "InDropdown", href: "/about" }),
        entry({ label: "New", href: "/new" }),
      ],
    });
    const navItems = [
      { link: "/events" },
      { dropdown: [{ link: "/about" }] },
    ];

    const items = await loadExtensionNavItems([], navItems);

    expect(items.map((i) => i.label)).toEqual(["New"]);
  });

  it.each([null, {}, { nav: "nope" }])("handles malformed manifest %j", async (payload) => {
    svc.getExtensionsManifest.mockResolvedValue(payload);

    expect(await loadExtensionNavItems([], [])).toEqual([]);
  });

  it("tolerates non-array scopes and nav items", async () => {
    svc.getExtensionsManifest.mockResolvedValue({
      nav: [entry({ requiresScopes: ["x"] }), entry({ label: "Open", href: "/open" })],
    });

    const items = await loadExtensionNavItems(undefined, undefined);

    expect(items.map((i) => i.label)).toEqual(["Open"]);
  });

  it("rejects when the manifest takes longer than 5 seconds", async () => {
    vi.useFakeTimers();
    svc.getExtensionsManifest.mockReturnValue(new Promise(() => {}));

    const pending = loadExtensionNavItems([], []);
    const assertion = expect(pending).rejects.toThrow("Extensions manifest timeout");
    await vi.advanceTimersByTimeAsync(5000);

    await assertion;
  });

  it("propagates manifest failures", async () => {
    svc.getExtensionsManifest.mockRejectedValue(new Error("500"));

    await expect(loadExtensionNavItems([], [])).rejects.toThrow("500");
  });
});

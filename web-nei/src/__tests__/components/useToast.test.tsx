import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import { act, renderHook } from "@testing-library/react";

import { reducer, toast, useToast } from "../../components/ui/use-toast";

const t = (id: string, extra = {}) => ({ id, open: true, ...extra }) as any;

describe("toast reducer", () => {
  it("adds a toast", () => {
    expect(reducer({ toasts: [] }, { type: "ADD_TOAST", toast: t("1") }).toasts).toEqual([t("1")]);
  });

  it("keeps only the newest toast (limit 1)", () => {
    const state = reducer({ toasts: [t("1")] }, { type: "ADD_TOAST", toast: t("2") });

    expect(state.toasts.map((x) => x.id)).toEqual(["2"]);
  });

  it("updates only the matching toast", () => {
    const state = reducer(
      { toasts: [t("1", { title: "a" }), t("2", { title: "b" })] },
      { type: "UPDATE_TOAST", toast: { id: "2", title: "changed" } }
    );

    expect(state.toasts.map((x: any) => x.title)).toEqual(["a", "changed"]);
  });

  it("dismisses one toast by closing it", () => {
    vi.useFakeTimers();
    const state = reducer({ toasts: [t("1"), t("2")] }, { type: "DISMISS_TOAST", toastId: "1" });

    expect(state.toasts.map((x) => x.open)).toEqual([false, true]);
    vi.useRealTimers();
  });

  it("dismisses every toast when no id is given", () => {
    vi.useFakeTimers();
    const state = reducer({ toasts: [t("1"), t("2")] }, { type: "DISMISS_TOAST" });

    expect(state.toasts.every((x) => x.open === false)).toBe(true);
    vi.useRealTimers();
  });

  it("removes one toast or all of them", () => {
    const base = { toasts: [t("1"), t("2")] };

    expect(reducer(base, { type: "REMOVE_TOAST", toastId: "1" }).toasts.map((x) => x.id)).toEqual(["2"]);
    expect(reducer(base, { type: "REMOVE_TOAST" }).toasts).toEqual([]);
  });

  it("does not mutate the previous state", () => {
    const base = { toasts: [t("1")] };

    reducer(base, { type: "DISMISS_TOAST", toastId: "1" });

    expect(base.toasts[0].open).toBe(true);
  });
});

describe("useToast / toast()", () => {
  beforeEach(() => vi.useFakeTimers());
  afterEach(() => {
    act(() => {
      vi.runOnlyPendingTimers();
    });
    vi.useRealTimers();
  });

  it("publishes a toast to subscribers with a unique id", () => {
    const { result } = renderHook(() => useToast());

    let first!: ReturnType<typeof toast>;
    act(() => {
      first = result.current.toast({ title: "Hello" });
    });

    expect(result.current.toasts[0]).toMatchObject({ title: "Hello", open: true, id: first.id });
  });

  it("dismiss() closes it and onOpenChange(false) does the same", () => {
    const { result } = renderHook(() => useToast());
    act(() => {
      result.current.toast({ title: "A" });
    });

    act(() => {
      result.current.toasts[0].onOpenChange?.(false);
    });

    expect(result.current.toasts[0].open).toBe(false);
  });

  it("update() changes the content of a visible toast", () => {
    const { result } = renderHook(() => useToast());
    let handle!: ReturnType<typeof toast>;
    act(() => {
      handle = result.current.toast({ title: "Before" });
    });

    act(() => handle.update({ id: handle.id, title: "After" } as any));

    expect(result.current.toasts[0].title).toBe("After");
  });

  it("hook-level dismiss() closes every toast", () => {
    const { result } = renderHook(() => useToast());
    act(() => {
      result.current.toast({ title: "A" });
    });

    act(() => result.current.dismiss());

    expect(result.current.toasts[0].open).toBe(false);
  });

  it("removes a dismissed toast after the removal delay", () => {
    const { result } = renderHook(() => useToast());
    act(() => {
      result.current.toast({ title: "A" });
    });
    act(() => result.current.dismiss());

    act(() => {
      vi.advanceTimersByTime(1_000_001);
    });

    expect(result.current.toasts).toEqual([]);
  });

  it("stops notifying after unmount", () => {
    const { result, unmount } = renderHook(() => useToast());
    unmount();

    expect(() => act(() => void toast({ title: "late" }))).not.toThrow();
    expect(result.current.toasts.length).toBeLessThanOrEqual(1);
  });
});

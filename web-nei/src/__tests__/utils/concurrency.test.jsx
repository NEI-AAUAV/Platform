import { runInChunks } from "../../utils/concurrency";
import { keyedByContent } from "../../utils/keys";

describe("runInChunks", () => {
  it("keeps input order, collects failures and reports each settled item", async () => {
    const seen = [];
    const results = await runInChunks(
      [1, 2, 3, 4, 5, 6, 7],
      async (n) => {
        if (n === 4) throw new Error("bad");
        return n * 2;
      },
      { limit: 3, onSettled: (r, i) => seen.push(i) }
    );
    expect(results.map((r) => r.status)).toEqual([
      "fulfilled", "fulfilled", "fulfilled", "rejected", "fulfilled", "fulfilled", "fulfilled",
    ]);
    expect(results[2].value).toBe(6);
    expect(results[3].reason.message).toBe("bad");
    expect(seen.sort()).toEqual([0, 1, 2, 3, 4, 5, 6]);
  });

  it("never runs more than `limit` workers at once", async () => {
    let active = 0;
    let peak = 0;
    await runInChunks(Array.from({ length: 12 }), async () => {
      active++;
      peak = Math.max(peak, active);
      await new Promise((r) => setTimeout(r, 1));
      active--;
    }, { limit: 5 });
    expect(peak).toBe(5);
  });
});

describe("keyedByContent", () => {
  it("builds unique keys from content with occurrence counters", () => {
    const keys = keyedByContent(["a", "b", "a"]).map((k) => k.key);
    expect(keys).toEqual(["a-0", "b-0", "a-1"]);
  });
});

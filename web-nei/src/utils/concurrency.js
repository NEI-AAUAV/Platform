/**
 * Run `worker(item, index)` over `items` with bounded concurrency:
 * at most `limit` workers are in flight at any time.
 * Never rejects: resolves with Promise.allSettled-style results in input order.
 * `onSettled(result, index)` is called as each item finishes.
 */
export async function runInChunks(items, worker, { limit = 5, onSettled } = {}) {
    const results = Array.from({ length: items.length });
    let next = 0;

    const settle = (index, result) => {
        results[index] = result;
        onSettled?.(result, index);
    };

    const runOne = (index) =>
        Promise.resolve()
            .then(() => worker(items[index], index))
            .then(
                (value) => settle(index, { status: "fulfilled", value }),
                (reason) => settle(index, { status: "rejected", reason })
            );

    // Each lane pulls the next pending index as soon as its previous item settles.
    const runLane = () => {
        if (next >= items.length) return Promise.resolve();
        return runOne(next++).then(runLane);
    };

    const lanes = Math.max(1, Math.min(limit, items.length));
    await Promise.all(Array.from({ length: lanes }, runLane));
    return results;
}

/** Callback ref that focuses an element when it mounts. */
export const focusOnMount = (element) => {
    element?.focus();
};

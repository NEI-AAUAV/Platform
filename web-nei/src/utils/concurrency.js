/**
 * Run `worker(item, index)` over `items` with bounded concurrency.
 * Items are processed in chunks of `limit`; chunks run sequentially.
 * Never rejects: resolves with Promise.allSettled-style results in input order.
 * `onSettled(result, index)` is called as each item finishes.
 */
export async function runInChunks(items, worker, { limit = 5, onSettled } = {}) {
    const results = new Array(items.length);
    for (let start = 0; start < items.length; start += limit) {
        const chunk = items.slice(start, start + limit);
        await Promise.allSettled(
            chunk.map(async (item, offset) => {
                const index = start + offset;
                try {
                    const value = await worker(item, index);
                    const result = { status: "fulfilled", value };
                    results[index] = result;
                    onSettled?.(result, index);
                    return value;
                } catch (reason) {
                    const result = { status: "rejected", reason };
                    results[index] = result;
                    onSettled?.(result, index);
                    throw reason;
                }
            })
        );
    }
    return results;
}

/** Callback ref that focuses an element when it mounts. */
export const focusOnMount = (element) => {
    element?.focus();
};

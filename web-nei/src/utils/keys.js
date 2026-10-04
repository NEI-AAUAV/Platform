/**
 * Build stable React keys from item content.
 * Repeated content gets an occurrence counter (`value-0`, `value-1`, ...), so keys
 * do not depend on the array position of unique items.
 * Returns `[{ item, key }]` in input order.
 */
export function keyedByContent(items, toContent = String) {
    const seen = new Map();
    return (items ?? []).map((item) => {
        const content = toContent(item);
        const occurrence = seen.get(content) ?? 0;
        seen.set(content, occurrence + 1);
        return { item, key: `${content}-${occurrence}` };
    });
}

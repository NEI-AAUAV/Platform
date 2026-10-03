import service from "services/NEIService";

const MANIFEST_TIMEOUT_MS = 5000;
const VISIBILITY_TIMEOUT_MS = 3000;

export const normalizeLink = (href) => {
  if (!href || typeof href !== "string") return href;
  try {
    // Convert absolute URLs to pathnames for comparison
    if (href.startsWith("http://") || href.startsWith("https://")) {
      return new URL(href, window.location.origin).pathname || "/";
    }
  } catch (_) {
    // Ignore errors: fall back to the original value
  }
  return href;
};

const toVisibleItem = (item) => ({ label: item.label, href: item.href });

const hasFallbackScope = (item, myScopes) =>
  !!item.dynamicVisibility.fallbackScopes?.some((scope) =>
    myScopes.includes(scope)
  );

/** Resolves to the visible item when a fallback scope applies, otherwise null. */
const fallbackItem = (item, myScopes) =>
  hasFallbackScope(item, myScopes) ? toVisibleItem(item) : null;

const fetchVisibilityData = async ({ dynamicVisibility }) => {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), VISIBILITY_TIMEOUT_MS);
  try {
    return await fetch(dynamicVisibility.endpoint, {
      signal: controller.signal,
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
      },
    });
  } finally {
    clearTimeout(timeoutId);
  }
};

const logVisibilityError = (item, error) => {
  if (error.name === "AbortError") {
    console.warn(`Dynamic visibility check timed out for ${item.label}`);
  } else {
    console.warn(`Failed to check dynamic visibility for ${item.label}:`, error);
  }
};

/** Check dynamic visibility for items that have it. */
export const checkDynamicVisibility = async (item, myScopes) => {
  if (!item.dynamicVisibility) return item;

  try {
    const response = await fetchVisibilityData(item);

    if (!response.ok) {
      console.warn(
        `Dynamic visibility endpoint returned ${response.status} for ${item.label}`
      );
      return fallbackItem(item, myScopes);
    }

    const data = await response.json();
    const { field, value } = item.dynamicVisibility;
    if (data[field] === value) return toVisibleItem(item);

    return fallbackItem(item, myScopes);
  } catch (error) {
    logVisibilityError(item, error);
    return fallbackItem(item, myScopes);
  }
};

const fetchManifest = () =>
  Promise.race([
    service.getExtensionsManifest(),
    new Promise((_, reject) =>
      setTimeout(
        () => reject(new Error("Extensions manifest timeout")),
        MANIFEST_TIMEOUT_MS
      )
    ),
  ]);

const collectExistingLinks = (navItems) =>
  new Set(
    (Array.isArray(navItems) ? navItems : [])
      .flatMap((i) => (i?.dropdown ? i.dropdown : [i]))
      .map((i) => normalizeLink(i?.link))
      .filter(Boolean)
  );

/** Load the extension nav items visible to a user with the given scopes. */
export const loadExtensionNavItems = async (scopes, navItems) => {
  const payload = await fetchManifest();
  const items = Array.isArray(payload?.nav) ? payload.nav : [];
  const myScopes = Array.isArray(scopes) ? scopes : [];
  const reqOk = (e) => {
    const req = Array.isArray(e?.requiresScopes) ? e.requiresScopes : [];
    return req.length === 0 || req.some((s) => myScopes.includes(s));
  };
  const existingLinks = collectExistingLinks(navItems);

  const filtered = items
    .filter(reqOk)
    .map((e) => ({
      label: e.label,
      href: e.href,
      key: normalizeLink(e.href),
      dynamicVisibility: e.dynamicVisibility,
      branded: e.branded ?? false,
    }))
    .filter((e) => !existingLinks.has(e.key));

  const processedItems = await Promise.all(
    filtered.map((item) => checkDynamicVisibility(item, myScopes))
  );
  return processedItems.filter(Boolean);
};

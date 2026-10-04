import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import axios, { AxiosError } from "axios";
import config from "../../config";

const store = vi.hoisted(() => ({
  state: { token: "old-token", login: vi.fn(), logout: vi.fn() },
}));
vi.mock("../../stores/useUserStore", () => ({
  useUserStore: { getState: () => store.state },
}));

import { createClient } from "../../services/client";

const SERVICE_URL = "http://svc.test";

/** Scripted backend: each call pops the next handler, recording the request. */
function scriptedBackend(client, handlers) {
  const seen = [];
  client.defaults.adapter = async (cfg) => {
    seen.push({
      url: cfg.url,
      authorization: cfg.headers.get("Authorization"),
      retry: cfg.retry,
    });
    const next = handlers.shift();
    if (!next) throw new Error("unexpected extra request");
    return next(cfg);
  };
  return seen;
}

const ok = (data) => (cfg) =>
  Promise.resolve({ data, status: 200, statusText: "OK", headers: {}, config: cfg });

const fail = (status, data = {}) => (cfg) =>
  Promise.reject(
    new AxiosError("failed", "ERR_BAD_REQUEST", cfg, null, {
      status,
      data,
      statusText: "",
      headers: {},
      config: cfg,
    })
  );

/** Replace the refresh endpoint (the only client created for API_NEI_URL). */
function mockRefresh(result) {
  const post = vi.fn(() =>
    result instanceof Error ? Promise.reject(result) : Promise.resolve({ data: result })
  );
  const realCreate = axios.create.bind(axios);
  vi.spyOn(axios, "create").mockImplementation((opts) =>
    opts?.baseURL === config.API_NEI_URL ? { post } : realCreate(opts)
  );
  return post;
}

beforeEach(() => {
  store.state = { token: "old-token", login: vi.fn(), logout: vi.fn() };
  // refreshToken() logs in with the new token; mirror what the real store does
  store.state.login.mockImplementation(({ token }) => {
    store.state.token = token;
  });
});

afterEach(() => {
  vi.restoreAllMocks();
});

describe("createClient interceptors", () => {
  it("sends the current access token as a bearer header", async () => {
    const client = createClient(SERVICE_URL);
    const seen = scriptedBackend(client, [ok({})]);

    await client.get("/x");

    expect(seen[0].authorization).toBe("Bearer old-token");
  });

  it("unwraps the response body", async () => {
    const client = createClient(SERVICE_URL);
    scriptedBackend(client, [ok({ items: [1, 2] })]);

    await expect(client.get("/x")).resolves.toEqual({ items: [1, 2] });
  });

  it("propagates non-401 errors untouched and never refreshes", async () => {
    const client = createClient(SERVICE_URL);
    scriptedBackend(client, [fail(500, { detail: "boom" })]);
    const post = mockRefresh({ access_token: "new" });

    await expect(client.get("/x")).rejects.toMatchObject({
      response: { status: 500, data: { detail: "boom" } },
    });
    expect(post).not.toHaveBeenCalled();
  });

  it("refreshes on 401 and retries once with the NEW token, returning unwrapped data", async () => {
    const client = createClient(SERVICE_URL);
    const seen = scriptedBackend(client, [fail(401), ok({ done: true })]);
    const post = mockRefresh({ access_token: "new-token" });

    const result = await client.get("/protected");

    expect(result).toEqual({ done: true });
    expect(post).toHaveBeenCalledWith("/auth/refresh");
    expect(store.state.login).toHaveBeenCalledWith({ token: "new-token" });
    expect(seen).toHaveLength(2);
    expect(seen[1].authorization).toBe("Bearer new-token");
    expect(seen[1].retry).toBe(true);
  });

  it("does not loop: a 401 on the retried request is surfaced as an error", async () => {
    const client = createClient(SERVICE_URL);
    const seen = scriptedBackend(client, [fail(401), fail(401)]);
    const post = mockRefresh({ access_token: "new-token" });

    await expect(client.get("/protected")).rejects.toMatchObject({
      response: { status: 401 },
    });
    expect(post).toHaveBeenCalledTimes(1);
    expect(seen).toHaveLength(2);
  });

  it("logs out and reports 'Session Expired' when the refresh fails", async () => {
    const client = createClient(SERVICE_URL);
    const seen = scriptedBackend(client, [fail(401)]);
    mockRefresh(new Error("refresh rejected"));

    await expect(client.get("/protected")).rejects.toThrow("Session Expired");

    expect(store.state.logout).toHaveBeenCalledTimes(1);
    expect(seen).toHaveLength(1); // no retry without a token
  });

  it("shares a single refresh between concurrent 401s and retries every request", async () => {
    const client = createClient(SERVICE_URL);
    let release;
    const gate = new Promise((resolve) => (release = resolve));
    const post = vi.fn(async () => {
      await gate;
      return { data: { access_token: "shared-token" } };
    });
    const realCreate = axios.create.bind(axios);
    vi.spyOn(axios, "create").mockImplementation((opts) =>
      opts?.baseURL === config.API_NEI_URL ? { post } : realCreate(opts)
    );
    const seen = scriptedBackend(client, [
      fail(401),
      fail(401),
      ok({ n: 1 }),
      ok({ n: 2 }),
    ]);

    const first = client.get("/a");
    const second = client.get("/b");
    await vi.waitFor(() => expect(seen).toHaveLength(2));
    release();
    const results = await Promise.all([first, second]);

    expect(post).toHaveBeenCalledTimes(1);
    expect(results.map((r) => r.n).sort()).toEqual([1, 2]);
    expect(seen.slice(2).every((r) => r.authorization === "Bearer shared-token")).toBe(true);
  });

  it("fails queued requests too when the shared refresh fails", async () => {
    const client = createClient(SERVICE_URL);
    let release;
    const gate = new Promise((resolve) => (release = resolve));
    const post = vi.fn(async () => {
      await gate;
      throw new Error("nope");
    });
    const realCreate = axios.create.bind(axios);
    vi.spyOn(axios, "create").mockImplementation((opts) =>
      opts?.baseURL === config.API_NEI_URL ? { post } : realCreate(opts)
    );
    const seen = scriptedBackend(client, [fail(401), fail(401)]);

    const first = client.get("/a");
    const second = client.get("/b");
    await vi.waitFor(() => expect(seen).toHaveLength(2));
    release();

    await expect(first).rejects.toThrow("Session Expired");
    await expect(second).rejects.toThrow("Session Expired");
    expect(post).toHaveBeenCalledTimes(1);
  });

  it("allows a later 401 to trigger a fresh refresh once the previous one finished", async () => {
    const client = createClient(SERVICE_URL);
    const post = mockRefresh({ access_token: "t2" });
    scriptedBackend(client, [fail(401), ok({}), fail(401), ok({})]);

    await client.get("/one");
    await client.get("/two");

    expect(post).toHaveBeenCalledTimes(2);
  });
});

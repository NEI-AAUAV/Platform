import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";

const store = vi.hoisted(() => ({ setGame: vi.fn() }));
vi.mock("../../stores/useSocketStore", () => ({
  useSocketStore: { getState: () => store },
}));

class FakeSocket {
  static CONNECTING = 0;
  static OPEN = 1;
  static CLOSING = 2;
  static CLOSED = 3;
  static instances = [];
  OPEN = 1;
  readyState = 1;
  constructor(url) {
    this.url = url;
    this.send = vi.fn();
    this.close = vi.fn();
    FakeSocket.instances.push(this);
  }
}

let service;

beforeEach(async () => {
  store.setGame.mockClear();
  FakeSocket.instances = [];
  vi.stubGlobal("WebSocket", FakeSocket);
  vi.resetModules(); // module-level singletons must start fresh for every test
  service = await import("../../services/SocketService");
  vi.spyOn(console, "info").mockImplementation(() => {});
  vi.spyOn(console, "error").mockImplementation(() => {});
});

afterEach(() => {
  vi.unstubAllGlobals();
  vi.restoreAllMocks();
});

describe("live games socket", () => {
  it("connects to /ws and reuses the same socket", () => {
    const first = service.getSocket();
    const second = service.getSocket();

    expect(FakeSocket.instances).toHaveLength(1);
    expect(first.socket).toBe(second.socket);
    expect(first.socket.url).toMatch(/\/api\/nei\/v1\/ws$/);
  });

  it("stores games pushed by the server", () => {
    const { socket } = service.getSocket();

    socket.onmessage({ data: JSON.stringify({ topic: "LIVE_GAMES", game: { id: 1 } }) });

    expect(store.setGame).toHaveBeenCalledWith({ id: 1 });
  });

  it("ignores messages for other topics", () => {
    const { socket } = service.getSocket();

    socket.onmessage({ data: JSON.stringify({ topic: "OTHER", game: { id: 1 } }) });

    expect(store.setGame).not.toHaveBeenCalled();
  });

  it("opens a fresh socket after the previous one closed", () => {
    const { socket } = service.getSocket();

    socket.onclose({ code: 1006, reason: "gone" });
    const next = service.getSocket();

    expect(next.socket).not.toBe(socket);
    expect(FakeSocket.instances).toHaveLength(2);
  });

  it("logs connection events without throwing", () => {
    const { socket } = service.getSocket();

    socket.onopen();
    socket.onerror({ message: "bad" });

    expect(console.error).toHaveBeenCalledWith("[error] bad");
  });

  it("getLiveGames asks the server for live games", async () => {
    const { socket, getLiveGames } = service.getSocket();

    await getLiveGames();

    expect(socket.send).toHaveBeenCalledWith(JSON.stringify({ topic: "LIVE_GAME" }));
  });

  it("wsend refuses to send on a socket that is not open", async () => {
    const { socket } = service.getSocket();
    socket.readyState = 3;

    await service.wsend({ a: 1 });

    expect(socket.send).not.toHaveBeenCalled();
    expect(console.error).toHaveBeenCalledWith("could not send ", { a: 1 });
  });

  it("wsend without any socket only logs", async () => {
    await service.wsend({ a: 1 });

    expect(console.error).toHaveBeenCalled();
  });
});

describe("arraial socket", () => {
  it("connects to /arraial/ws and reuses a live socket", () => {
    const first = service.getArraialSocket();
    const second = service.getArraialSocket();

    expect(first).toBe(second);
    expect(first.url).toMatch(/\/arraial\/ws$/);
  });

  it.each([2, 3])("replaces a socket in readyState %i", (state) => {
    const first = service.getArraialSocket();
    first.readyState = state;

    expect(service.getArraialSocket()).not.toBe(first);
  });

  it("destroy closes the socket and the next call reconnects", () => {
    const first = service.getArraialSocket();

    service.destroyArraialSocket();

    expect(first.close).toHaveBeenCalled();
    expect(service.getArraialSocket()).not.toBe(first);
  });

  it("destroy without a socket is a no-op", () => {
    expect(() => service.destroyArraialSocket()).not.toThrow();
  });
});

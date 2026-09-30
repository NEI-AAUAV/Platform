import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import axios from "axios";

vi.mock("axios", () => ({ default: { get: vi.fn() } }));
vi.mock("../../config", () => ({
  default: { GOOGLE_CALENDAR_URL: "https://gcal.test" },
}));

import service from "../../services/GoogleCalendarService";

const params = { timeMin: "2026-9-1T00:00:00+01:00", timeMax: "2026-9-30T00:00:00+01:00" };

describe("GoogleCalendarService", () => {
  beforeEach(() => {
    axios.get.mockReset();
  });
  afterEach(() => {
    vi.restoreAllMocks();
  });

  describe("getCalendarEvents", () => {
    it("requests the encoded calendar with default params", async () => {
      axios.get.mockResolvedValue({ data: { items: [] } });

      await service.getCalendarEvents("a@group.calendar.google.com", params);

      const [url, options] = axios.get.mock.calls[0];
      expect(url).toBe(
        "https://gcal.test/calendars/a%40group.calendar.google.com/events"
      );
      expect(options.params).toMatchObject({
        ...params,
        singleEvents: true,
        maxResults: 9999,
        orderBy: "startTime",
      });
      expect(options.params.key).toBeTruthy();
    });

    it("allows overriding singleEvents and maxResults", async () => {
      axios.get.mockResolvedValue({ data: { items: [] } });

      await service.getCalendarEvents("id", {
        ...params,
        singleEvents: false,
        maxResults: 5,
      });

      expect(axios.get.mock.calls[0][1].params).toMatchObject({
        singleEvents: false,
        maxResults: 5,
      });
    });
  });

  describe("getEvents", () => {
    it("merges the events of all calendars", async () => {
      axios.get
        .mockResolvedValueOnce({ data: { items: [{ id: "1" }] } })
        .mockResolvedValueOnce({ data: { items: [{ id: "2" }, { id: "3" }] } });

      const { data } = await service.getEvents(params);

      expect(axios.get).toHaveBeenCalledTimes(2);
      expect(data.items.map((e) => e.id)).toEqual(["1", "2", "3"]);
    });

    it("skips a failing calendar and logs the error", async () => {
      const error = vi.spyOn(console, "error").mockImplementation(() => {});
      const failure = new Error("boom");
      axios.get
        .mockRejectedValueOnce(failure)
        .mockResolvedValueOnce({ data: { items: [{ id: "2" }] } });

      const { data } = await service.getEvents(params);

      expect(data.items).toEqual([{ id: "2" }]);
      expect(error).toHaveBeenCalledWith(
        "Failed to load calendar events",
        failure
      );
    });

    it("throws the first error when every calendar fails", async () => {
      const first = new Error("first");
      axios.get
        .mockRejectedValueOnce(first)
        .mockRejectedValueOnce(new Error("second"));

      await expect(service.getEvents(params)).rejects.toBe(first);
    });
  });
});

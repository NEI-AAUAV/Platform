import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";

const http = vi.hoisted(() => ({
  get: vi.fn(),
  post: vi.fn(),
  put: vi.fn(),
  delete: vi.fn(),
}));
vi.mock("../../services/client", () => ({ createClient: () => http }));

import TacaUAService from "../../services/TacaUAService";

beforeEach(() => {
  Object.values(http).forEach((fn) => fn.mockReset().mockResolvedValue("payload"));
});

describe("TacaUAService request contract", () => {
  const D = { a: 1 };
  const cases = [
    ["createModality", [{ data: D }], "post", "/modalities", [D]],
    ["getModalitybyId", [2], "get", "/modalities/2", []],
    ["updateModality", [{ id: 2, data: D }], "put", "/modalities/2", [D]],
    ["removeModality", [2], "delete", "/modalities/2", []],
    ["createCompetition", [D], "post", "/competitions/", [D]],
    ["updateCompetition", [3, D], "put", "/competitions/3", [D]],
    ["removeCompetition", [3], "delete", "/competitions/3", []],
    ["createTeam", [D], "post", "/teams/", [D]],
    ["updateTeam", [3, D], "put", "/teams/3", [D]],
    ["removeTeam", [3], "delete", "/teams/3", []],
    ["createParticipant", [D], "post", "/participants/", [D]],
    ["updateParticipant", [3, D], "put", "/participants/3", [D]],
    ["removeParticipant", [3], "delete", "/participants/3", []],
    ["getCourses", [], "get", "/courses/", []],
    ["createCourse", [D], "post", "/courses", [D]],
    ["getCoursebyId", [3], "get", "/courses/3", []],
    ["updateCourse", [3, D], "put", "/courses/3", [D]],
    ["removeCourse", [3], "delete", "/courses/3", []],
    ["createGroup", [D], "post", "/groups/", [D]],
    ["updateGroup", [3, D], "put", "/groups/3", [D]],
    ["removeGroup", [3], "delete", "/groups/3", []],
    ["addTeamToGroup", [3, D], "post", "/groups/3/teams", [D]],
    ["updateMatch", [3, D], "put", "/matches/3", [D]],
    ["get_next_matches", [D], "get", "/matches/next_played", [D]],
    ["get_last_matches", [D], "get", "/matches/last_played", [D]],
    ["getStanding", [3], "get", "/standings/3", []],
    ["createStanding", [D], "post", "/standings/", [D]],
  ];

  it.each(cases)("%s -> %s %s", async (method, args, verb, url, trailing) => {
    expect(await TacaUAService[method](...args)).toBe("payload");

    expect(http[verb]).toHaveBeenCalledTimes(1);
    expect(http[verb]).toHaveBeenCalledWith(url, ...trailing);
  });

  describe("getModalities", () => {
    beforeEach(() => vi.useFakeTimers().setSystemTime(new Date(1_700_000_000_000)));
    afterEach(() => vi.useRealTimers());

    it("cache-busts with a timestamp query so lists are never stale", async () => {
      await TacaUAService.getModalities();

      expect(http.get).toHaveBeenCalledWith("/modalities/?t=1700000000000");
    });
  });
});

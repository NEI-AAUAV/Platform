import { describe, it, expect, vi, beforeEach } from "vitest";

const http = vi.hoisted(() => ({
  get: vi.fn(),
  post: vi.fn(),
  put: vi.fn(),
  delete: vi.fn(),
}));
vi.mock("../../services/client", () => ({ createClient: () => http }));

import NEIService from "../../services/NEIService";

beforeEach(() => {
  Object.values(http).forEach((fn) => fn.mockReset().mockResolvedValue("payload"));
});

const P = { year: 2020 };

describe("NEIService request contract", () => {
  const cases = [
    ["getNotes", [P], "get", "/note", [{ params: P }]],
    ["getNotesById", [3], "get", "/note/3", []],
    ["getNotesYears", [P], "get", "/note/year", [{ params: P }]],
    ["getNotesSubjects", [P], "get", "/note/subject", [{ params: P }]],
    ["getNotesStudents", [P], "get", "/note/student", [{ params: P }]],
    ["getNotesTeachers", [P], "get", "/note/teacher", [{ params: P }]],
    ["getNotesCurricularYears", [P], "get", "/note/curricular-year", [{ params: P }]],
    ["getRGM", [P], "get", "/rgm/", [{ params: P }]],
    ["getRGMMandates", [], "get", "/rgm/mandates/", []],
    ["getHistory", [], "get", "/history/", []],
    ["getMerch", [], "get", "/merch/", []],
    ["getPartners", [], "get", "/partner/", []],
    ["getTeamMandates", [], "get", "/team/mandate/", []],
    ["getTeamMandateTree", ["2026/27"], "get", "/team/mandate/2026/27", []],
    ["getFainaMandates", [P], "get", "/faina/", [{ params: P }]],
    ["getNewsCategories", [P], "get", "/news/category/", [{ params: P }]],
    ["getNewsById", [5], "get", "/news/5", []],
    ["getNews", [P], "get", "/news/", [{ params: P }]],
    ["getVideosCategories", [P], "get", "/video/category/", [{ params: P }]],
    ["getVideosById", [5], "get", "/video/5", []],
    ["getVideos", [P], "get", "/video/", [{ params: P }]],
    ["getRedirects", [P], "get", "/redirect/", [{ params: P }]],
    ["getSeniorsCourse", [], "get", "/senior/course", []],
    ["getSeniorsCourseYear", ["LEI"], "get", "/senior/LEI/year", []],
    ["getSeniorsBy", ["LEI", 2020], "get", "/senior/LEI/2020", []],
    ["getCurrUser", [], "get", "/user/me", []],
    ["updateCurrUser", [{ name: "A" }], "put", "/user/me", [{ name: "A" }]],
    ["login", [{ u: 1 }], "post", "/auth/login/", [{ u: 1 }]],
    ["register", [{ e: 1 }], "post", "/auth/register/", [{ e: 1 }, { timeout: 15000 }]],
    ["logout", [], "post", "/auth/logout", []],
    ["verifyEmail", [{ token: "x" }], "get", "/auth/verify/", [{ params: { token: "x" } }]],
    ["forgotPassword", [{ email: "a" }], "post", "/auth/forgot/", [{ email: "a" }]],
    ["resetPassword", [{ p: 1 }, { token: "t" }], "post", "/auth/reset/", [{ p: 1 }, { params: { token: "t" } }]],
    ["getArraialPoints", [], "get", "/arraial/points", []],
    ["updateArraialPoints", [{ NEI: 1 }], "put", "/arraial/points", [{ NEI: 1 }]],
    ["getArraialConfig", [], "get", "/arraial/config", []],
    ["setArraialConfig", [{ paused: true }], "put", "/arraial/config", [{ paused: true }]],
    ["activateArraialBoost", ["NEI"], "post", "/arraial/boost/NEI", []],
    ["rollbackArraial", [12], "post", "/arraial/rollback/12", []],
    ["resetArraial", [], "post", "/arraial/reset", []],
    ["getUsers", [], "get", "/user/", []],
    ["updateUserScopes", [4, ["admin"]], "put", "/user/4", [{ scopes: ["admin"] }]],
    ["getDynamicScopes", [], "get", "/auth/scopes", []],
    ["getExtensionsManifest", [], "get", "/extensions/manifest", []],
    ["signOutEverywhere", [4], "post", "/admin/users/4/sign-out", []],
    ["getSystemStatus", [], "get", "/admin/system", []],
    ["getCmsInfo", [], "get", "/admin/cms", []],
    ["getAuthentikStatus", [], "get", "/admin/authentik/status", []],
    ["getAuthentikGroups", [], "get", "/admin/authentik/groups", []],
    ["addUserToAuthentikGroup", ["g1", 4], "post", "/admin/authentik/groups/g1/members/4", []],
    ["removeUserFromAuthentikGroup", ["g1", 4], "delete", "/admin/authentik/groups/g1/members/4", []],
  ];

  it.each(cases)("%s -> %s %s", async (method, args, verb, url, trailing) => {
    const result = await NEIService[method](...args);

    expect(http[verb]).toHaveBeenCalledTimes(1);
    expect(http[verb]).toHaveBeenCalledWith(url, ...trailing);
    expect(result).toBe("payload");
    Object.keys(http)
      .filter((v) => v !== verb)
      .forEach((v) => expect(http[v]).not.toHaveBeenCalled());
  });

  it("getArraialLog defaults to the first page of 25 and merges filters", async () => {
    await NEIService.getArraialLog();
    await NEIService.getArraialLog(10, 20, { nucleo: "NEI" });

    expect(http.get).toHaveBeenNthCalledWith(1, "/arraial/log", { params: { limit: 25, offset: 0 } });
    expect(http.get).toHaveBeenNthCalledWith(2, "/arraial/log", {
      params: { limit: 10, offset: 20, nucleo: "NEI" },
    });
  });

  it("getAdminActivity defaults to the first page of 50", async () => {
    await NEIService.getAdminActivity();
    await NEIService.getAdminActivity(100, 10);

    expect(http.get).toHaveBeenNthCalledWith(1, "/admin/activity", { params: { offset: 0, limit: 50 } });
    expect(http.get).toHaveBeenNthCalledWith(2, "/admin/activity", { params: { offset: 100, limit: 10 } });
  });

  it("magicLink posts the password as multipart form data with the token in the query", async () => {
    await NEIService.magicLink({ token: "tok", password: "secret-pw" });

    const [url, form] = http.post.mock.calls[0];
    expect(url).toBe("/auth/magic?token=tok");
    expect(form).toBeInstanceOf(FormData);
    expect(form.get("password")).toBe("secret-pw");
  });

  it("propagates failures", async () => {
    http.get.mockRejectedValueOnce(new Error("down"));

    await expect(NEIService.getHistory()).rejects.toThrow("down");
  });
});

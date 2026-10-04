import { describe, it, expect, vi, beforeEach } from "vitest";

const http = vi.hoisted(() => ({
  get: vi.fn(),
  post: vi.fn(),
  put: vi.fn(),
  delete: vi.fn(),
}));
vi.mock("../../services/client", () => ({ createClient: () => http }));

import config from "../../config";
import FamilyService from "../../services/FamilyService";

beforeEach(() => {
  Object.values(http).forEach((fn) => fn.mockReset().mockResolvedValue("payload"));
});

describe("FamilyService request contract", () => {
  const cases = [
    // [method, args, http verb, url, trailing args]
    ["getTree", [{ depth: 2 }], "get", "/tree/", [{ params: { depth: 2 } }]],
    ["getTree", [], "get", "/tree/", [{ params: {} }]],
    ["getUsers", [{ skip: 5, limit: 10 }], "get", "/user/", [{ params: { skip: 5, limit: 10 } }]],
    ["getYears", [], "get", "/user/years", []],
    ["getUserById", [7], "get", "/user/7", []],
    ["getUserChildren", [7], "get", "/user/7/children", []],
    ["createUser", [{ name: "A" }], "post", "/user/", [{ name: "A" }]],
    ["updateUser", [7, { name: "B" }], "put", "/user/7", [{ name: "B" }]],
    ["deleteUser", [7], "delete", "/user/7", []],
    ["getCourses", [{ degree: "Mestrado" }], "get", "/course/", [{ params: { degree: "Mestrado" } }]],
    ["getCourseById", [3], "get", "/course/3", []],
    ["createCourse", [{ short: "LEI" }], "post", "/course/", [{ short: "LEI" }]],
    ["updateCourse", [3, { name: "x" }], "put", "/course/3", [{ name: "x" }]],
    ["deleteCourse", [3], "delete", "/course/3", []],
    ["getRoles", [], "get", "/role/", []],
    ["getRoleTree", [], "get", "/role/tree", []],
    ["createRole", [{ name: "R" }], "post", "/role/", [{ name: "R" }]],
    ["updateRole", [".1.2.", { name: "R" }], "put", "/role/.1.2.", [{ name: "R" }]],
    ["deleteRole", [".1.2."], "delete", "/role/.1.2.", []],
    ["getUserRolesWithDetails", [{ user_id: 1 }], "get", "/userrole/details", [{ params: { user_id: 1 } }]],
    ["getRolesForUser", [9], "get", "/userrole/user/9", []],
    ["assignRole", [{ user_id: 1, role_id: ".1.", year: 20 }], "post", "/userrole/", [{ user_id: 1, role_id: ".1.", year: 20 }]],
    ["removeRole", ["abc"], "delete", "/userrole/abc", []],
  ];

  it.each(cases)("%s -> %s %s", async (method, args, verb, url, trailing) => {
    const result = await FamilyService[method](...args);

    expect(http[verb]).toHaveBeenCalledTimes(1);
    expect(http[verb]).toHaveBeenCalledWith(url, ...trailing);
    expect(result).toBe("payload");
    const others = Object.keys(http).filter((v) => v !== verb);
    others.forEach((v) => expect(http[v]).not.toHaveBeenCalled());
  });

  it("targets the family API", async () => {
    expect(config.API_FAMILY_URL).toMatch(/\/api\/family\/v1$/);
  });

  it("bulkCreateUsers defaults to a real, non-atomic import", async () => {
    await FamilyService.bulkCreateUsers([{ name: "A" }]);

    expect(http.post).toHaveBeenCalledWith("/user/bulk", [{ name: "A" }], {
      params: { dry_run: false, atomic: false },
    });
  });

  it("bulkCreateUsers forwards dry_run and atomic", async () => {
    await FamilyService.bulkCreateUsers([], { dry_run: true, atomic: true });

    expect(http.post.mock.calls[0][2]).toEqual({ params: { dry_run: true, atomic: true } });
  });

  it("propagates API errors to the caller", async () => {
    http.get.mockRejectedValueOnce(new Error("boom"));

    await expect(FamilyService.getYears()).rejects.toThrow("boom");
  });

  describe("updateUserImage", () => {
    it("uploads the file as multipart form data with a long timeout", async () => {
      const file = new File(["x"], "a.png", { type: "image/png" });

      await FamilyService.updateUserImage(4, file);

      const [url, form, opts] = http.put.mock.calls[0];
      expect(url).toBe("/user/4/image");
      expect(form).toBeInstanceOf(FormData);
      expect(form.get("image")).toBe(file);
      expect(form.get("remove")).toBe("false");
      expect(opts).toMatchObject({ timeout: 30000, maxBodyLength: Infinity });
      expect(opts.headers).toBeUndefined(); // the browser must set the multipart boundary
    });

    it("sends only the remove flag when removing", async () => {
      await FamilyService.updateUserImage(4, null, { remove: true });

      const form = http.put.mock.calls[0][1];
      expect(form.has("image")).toBe(false);
      expect(form.get("remove")).toBe("true");
    });
  });
});

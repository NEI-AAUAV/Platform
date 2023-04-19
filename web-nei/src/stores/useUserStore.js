import { create } from "zustand";

import { parseJWT } from "utils";

const defaultReducedAnimation =
  !!localStorage.getItem("an") ||
  window.matchMedia("(prefers-reduced-motion: reduce)").matches;

const defaultTheme =
  localStorage.getItem("th") ||
  (window.matchMedia("(prefers-color-scheme: dark)").matches
    ? "dark"
    : "light");
document.body.setAttribute("data-theme", defaultTheme);

export const useUserStore = create((set, get) => ({
  theme: defaultTheme,
  reducedAnimation: defaultReducedAnimation,
  sub: null,
  name: null,
  surname: null,
  token: null,
  image: null,
  toggleReducedAnimation: () => {
    const value = get().reducedAnimation;
    value ? localStorage.removeItem("an") : localStorage.setItem("an", 1);
    set(() => ({ reducedAnimation: !value }));
  },
  setTheme: (theme) => {
    localStorage.setItem("th", theme);
    document.body.setAttribute("data-theme", theme);
    set(() => ({ theme }));
  },
  login: ({ token }) => {
    const payload = parseJWT(token);
    set(() => ({ token, ...payload }));
  },

  logout: () => {
    set(() => ({ name: null, surname: null, token: null }));
  },
}));

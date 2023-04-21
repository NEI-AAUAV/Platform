import { create } from "zustand";

import { parseJWT } from "utils";

const defaultTheme =
  localStorage.getItem("th") ||
  (window.matchMedia("(prefers-color-scheme: dark)").matches
    ? "dark"
    : "light");
document.body.setAttribute("data-theme", defaultTheme);

export const useUserStore = create((set, get) => ({
  sessionLoading: true,
  theme: defaultTheme,
  sub: null,
  name: null,
  surname: null,
  token: null,

  setTheme: (theme) => {
    localStorage.setItem("th", theme);
    document.body.setAttribute("data-theme", theme);
    set(() => ({ theme }));
  },

  login: ({ token }) => {
    const payload = token ? parseJWT(token) : {};
    set(() => ({ token, sessionLoading: false, ...payload }));
  },

  logout: () => {
    set(() => ({
      name: null,
      surname: null,
      token: null,
      sessionLoading: false,
    }));
  },
}));

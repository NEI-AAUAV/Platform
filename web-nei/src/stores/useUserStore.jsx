import { create } from "zustand";

import { parseJWT } from "utils";

const defaultTheme =
  localStorage.getItem("th") ||
  (window.matchMedia("(prefers-color-scheme: dark)").matches
    ? "dark"
    : "light");
document.body.setAttribute("class", defaultTheme);
document.body.setAttribute("data-theme", defaultTheme);
document.documentElement.className = defaultTheme === "dark" ? "dark" : "";

export const useUserStore = create((set, get) => ({
  sessionLoading: true,
  theme: defaultTheme,
  image: null,
  sub: null,
  name: null,
  surname: null,
  token: null,

  setTheme: (theme) => {
    localStorage.setItem("th", theme);
    document.body.setAttribute("class", theme);
    document.body.setAttribute("data-theme", theme);
    document.documentElement.className = theme === "dark" ? "dark" : "";
    set(() => ({ theme }));
  },

  login: ({ token }) => {
    const payload = token ? parseJWT(token) : {};

    set(() => ({
      token,
      sessionLoading: false,
      ...payload,
    }));
  },

  logout: () => {
    set(() => ({
      name: null,
      surname: null,
      token: null,
      image: null,
      sessionLoading: false,
    }));
  },
}));

import { create } from "zustand";

import { parseJWT } from "utils";

const defaultTheme =
  localStorage.getItem("th") ||
  (window.matchMedia("(prefers-color-scheme: dark)").matches
    ? "dark"
    : "light");
document.body.setAttribute("data-theme", defaultTheme);

export const useUserStore = create((set) => ({
  theme: defaultTheme,
  name: null,
  surname: null,
  token: null,
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
    set(() => ({ token: null }));
  },
}));

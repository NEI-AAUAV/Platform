import { create } from "zustand";

import { parseJWT } from "utils";
import config from "config"

const defaultTheme =
  localStorage.getItem("th") ||
  (window.matchMedia("(prefers-color-scheme: dark)").matches
    ? "dark"
    : "light");
document.body.setAttribute("data-theme", defaultTheme);

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
    document.body.setAttribute("data-theme", theme);
    set(() => ({ theme }));
  },

  login: ({ token }) => {
    const { img, ...payload } = token ? parseJWT(token) : {};

    set(() => ({
      token,
      sessionLoading: false,
      ...payload,
      image: img && config.NEI_STATIC_URL + `/users/${payload.sub}/profile.jpg`,
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

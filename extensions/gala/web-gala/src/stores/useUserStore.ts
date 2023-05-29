import { create } from "zustand";
import { shallow } from "zustand/shallow";

function parseJWT(token: string) {
  let base64Url = token.split(".")[1];
  let base64 = base64Url.replace(/-/g, "+").replace(/_/g, "/");
  let jsonPayload = decodeURIComponent(
    window
      .atob(base64)
      .split("")
      .map((c) => "%" + ("00" + c.charCodeAt(0).toString(16)).slice(-2))
      .join(""),
  );
  return JSON.parse(jsonPayload);
}

const defaultTheme =
  localStorage.getItem("th") ||
  (window.matchMedia("(prefers-color-scheme: dark)").matches
    ? "dark"
    : "light");
document.body.setAttribute("data-theme", defaultTheme);

interface TokenPayload {
  image?: string;
  sub?: number;
  name?: string;
  surname?: string;
}

interface UserState extends TokenPayload {
  sessionLoading: boolean;
  theme?: string;
  token?: string;
  setTheme: (theme: string) => void;
  login: ({ token }: { token: string }) => void;
  logout: () => void;
}

const useUserStore = create<UserState>((set, get) => ({
  sessionLoading: true,
  theme: defaultTheme,

  setTheme: (theme) => {
    localStorage.setItem("th", theme);
    document.body.setAttribute("data-theme", theme);
    set(() => ({ theme }));
  },

  login: ({ token }) => {
    const { image, ...payload }: TokenPayload = token ? parseJWT(token) : {};
    set((state) => ({
      ...state,
      token,
      sessionLoading: false,
      ...payload,
      image: image || `http://localhost/gala/public/default-profile.svg`,
    }));
  },

  logout: () => {
    set(() => ({
      sessionLoading: false,
      image: undefined,
      sub: undefined,
      name: undefined,
      surname: undefined,
      token: undefined,
    }));
  },
}));

export { useUserStore, shallow };

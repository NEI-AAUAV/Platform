import { OpenAPI } from "@/client";
import { create } from "zustand";
import { shallow } from "zustand/shallow";

function parseJWT(token: string) {
  const base64Url = token.split(".")[1];
  const base64 = base64Url?.replace(/-/g, "+").replace(/_/g, "/");
  const jsonPayload = decodeURIComponent(
    window
      .atob(base64 ?? "")
      .split("")
      .map((c) => `%${`00${c.charCodeAt(0).toString(16)}`.slice(-2)}`)
      .join(""),
  );
  return JSON.parse(jsonPayload) as TokenPayload;
}

type TokenPayload = {
  image?: string;
  sub?: string;
  email?: string;
  name?: string;
  surname?: string;
  scopes?: string[];
};

type UserState = TokenPayload & {
  sessionLoading: boolean;
  token?: string;
  login: ({ token }: { token: string }) => void;
  logout: () => void;
};

const useUserStore = create<UserState>((set) => ({
  sessionLoading: true,

  login: ({ token }) => {
    const payload: TokenPayload = token ? parseJWT(token) : {};
    OpenAPI.HEADERS = {
      Authorization: `Bearer ${token}`,
    };
    set((state) => ({
      ...state,
      token,
      sessionLoading: false,
      ...payload,
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

import config from "@/config";
import { useHref } from "react-router-dom";

export default function useLoginLink() {
  const homePathname = useHref("");
  const loginURL = new URL("/auth/login", config.BASE_URL);
  const redirectUrl = new URL(homePathname, config.BASE_URL);

  loginURL.searchParams.set("redirect_to", redirectUrl.toString());

  return loginURL.toString();
}

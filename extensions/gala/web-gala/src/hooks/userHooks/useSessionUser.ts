import useSWR from "swr";
import GalaService from "@/services/GalaService";
import { useUserStore } from "@/stores/useUserStore";

export const State = {
  NONE: 0,
  AUTHENTICATED: 1,
  REGISTERED: 2,
};

export default function useSessionUser() {
  const { image, sub, email, name, surname, scopes } = useUserStore(
    (state) => state,
  );
  const { data, error, isLoading, mutate } = useSWR<User>(
    "/user/me",
    () => GalaService.user.getSessionUser(),
    // We want to query the first time but cache that result across componentes.
    // Since `revalidateOnMount: false` doesn't make a first request, we need to
    // change the dedup interval to always dedup.
    // Source: https://github.com/vercel/swr/issues/943#issuecomment-1514571807
    { dedupingInterval: 10000000 },
  );

  let state = State.NONE;
  if (sub !== undefined) {
    state = State.AUTHENTICATED;
  }
  if (data !== undefined) {
    state = State.REGISTERED;
  }

  return {
    sessionUser: { ...data, image, sub, name, email, surname, scopes },
    state,
    isError: error,
    isLoading,
    mutate,
  };
}

import GalaService from "@/services/GalaService";
import useSWR from "swr";

export default function useSessionUser() {
  const { data, error, isLoading, mutate } = useSWR<User>(
    "/user/me",
    () => GalaService.user.getSessionUser(),
    // We want to query the first time but cache that result across componentes.
    // Since `revalidateOnMount: false` doesn't make a first request, we need to
    // change the dedup interval to always dedup.
    // Source: https://github.com/vercel/swr/issues/943#issuecomment-1514571807
    { dedupingInterval: 10000000 },
  );
  return { sessionUser: data, isError: error, isLoading, mutate };
}

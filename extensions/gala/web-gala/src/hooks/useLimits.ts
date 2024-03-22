import useSWR from "swr";
import GalaService, { Limits } from "@/services/GalaService";

export default function useLimits() {
  const { data, error, isLoading, mutate } = useSWR<Limits>(
    "/limits",
    () => GalaService.limits.getLimits(),
    // We want to query the first time but cache that result across componentes.
    // Since `revalidateOnMount: false` doesn't make a first request, we need to
    // change the dedup interval to always dedup.
    // Source: https://github.com/vercel/swr/issues/943#issuecomment-1514571807
    { dedupingInterval: 10000000 },
  );

  return { limits: data, isLoading, isError: error, refresh: mutate };
}

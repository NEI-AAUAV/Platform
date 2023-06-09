import useSWR from "swr";
import GalaService from "@/services/GalaService";
import useSessionUser from "../userHooks/useSessionUser";

export default function useTables() {
  const { sessionUser, isLoading: isUserLoading, isError } = useSessionUser();
  const { data, error, isLoading, mutate } = useSWR<Table[]>(
    () => (isUserLoading && !isError ? null : ["/table/list", sessionUser]),
    () =>
      sessionUser
        ? GalaService.table.listTables()
        : GalaService.table.listTablesPublic(),
    { refreshInterval: 30_000, dedupingInterval: 15_000 },
  );

  return {
    tables: data ?? [],
    isLoading,
    isError: error,
    mutate,
  };
}

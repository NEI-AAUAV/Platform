import useSWR, { State } from "swr";
import useSessionUser from "../userHooks/useSessionUser";
import GalaService from "@/services/GalaService";

export default function useTables() {
  const {
    sessionUser,
    state,
    isLoading: isUserLoading,
    isError,
  } = useSessionUser();
  const { data, error, isLoading, mutate } = useSWR<Table[]>(
    () => (isUserLoading && !isError ? null : ["/table/list", sessionUser]),
    () =>
      state === State.NONE
        ? GalaService.table.listTablesPublic()
        : GalaService.table.listTables(),
    { refreshInterval: 30_000, dedupingInterval: 15_000 },
  );

  return {
    tables: data ?? [],
    isLoading,
    isError: error,
    mutate,
  };
}

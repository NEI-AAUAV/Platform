import useSWR from "swr";
import NEIService from "@/services/NEIService";

export default function useNEIUser(id: number | null) {
  const { data, error, isLoading } = useSWR<NEIUser>(
    id === null ? null : ["/nei/user", id],
    () => NEIService.getUserById(id!),
    // Don't refresh the user unless 60 seconds have passed
    { dedupingInterval: 60_000 },
  );

  return { neiUser: data, isLoading, isError: error };
}

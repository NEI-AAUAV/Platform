import GalaService from "@/services/GalaService";
import useTables from "./useTables";

export default function useTable(id: number) {
  const { tables, isLoading, mutate: mutateTables } = useTables();
  const table = tables.find((table) => table._id === id);

  const mutate = () => {
    mutateTables(async (tables) => {
      if (!tables) return tables;
      const newTable = await GalaService.table.getTable(id);
      return tables.map((table) => (table._id === id ? newTable : table));
    });
  };

  return { table, mutate, isLoading };
}

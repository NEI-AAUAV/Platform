import GalaService from "@/services/GalaService";

export default async function useTableLeave(id: string | number) {
  await GalaService.table.tableLeave(id);
}

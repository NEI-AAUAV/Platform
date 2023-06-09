import GalaService from "@/services/GalaService";

export default async function useTableEdit(
  id: number,
  request: { name: string },
) {
  await GalaService.table.editTable(id, request);
}

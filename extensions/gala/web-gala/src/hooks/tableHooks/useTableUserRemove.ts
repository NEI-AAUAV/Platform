import GalaService from "@/services/GalaService";

export default async function useTableUserRemove(
  id: number,
  uid: number | string,
) {
  await GalaService.table.tableRemoveUser(id, uid);
}

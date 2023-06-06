import GalaService from "@/services/GalaService";

export default function useTableUserRemove(id: number, uid: number | string) {
  GalaService.table.tableRemoveUser(id, uid);
}

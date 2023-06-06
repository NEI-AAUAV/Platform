import GalaService from "@/services/GalaService";

export default function useTableEdit(id: number, request: { name: string }) {
  GalaService.table.editTable(id, request);
}

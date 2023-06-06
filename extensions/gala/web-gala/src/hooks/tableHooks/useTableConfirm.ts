import GalaService from "@/services/GalaService";

type Confirmation = {
  uid: number;
  confirm: boolean;
};

export default function useTableConfirm(
  id: string | number,
  request: Confirmation,
) {
  GalaService.table.confirmTable(id, request);
}

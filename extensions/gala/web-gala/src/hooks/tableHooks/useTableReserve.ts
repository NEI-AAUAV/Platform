import GalaService from "@/services/GalaService";

type ReserveTable = {
  dish: string;
  allergies: string;
  companions: {
    dish: string;
    allergies: string;
  }[];
};

export default function useTableReserve(id: number, request: ReserveTable) {
  GalaService.table.reserveTable(id, request);
}

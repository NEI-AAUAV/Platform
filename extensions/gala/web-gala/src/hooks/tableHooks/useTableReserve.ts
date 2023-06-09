import GalaService from "@/services/GalaService";

type ReserveTable = {
  dish: string;
  allergies: string;
  companions: {
    dish: string;
    allergies: string;
  }[];
};

export default async function useTableReserve(
  id: number,
  request: ReserveTable,
) {
  await GalaService.table.reserveTable(id, request);
}

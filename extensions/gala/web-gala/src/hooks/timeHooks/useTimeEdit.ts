import GalaService from "@/services/GalaService";

type EditTimeSlots = {
  votesStart?: string;
  votesEnd?: string;
  tablesStart?: string;
  tablesEnd?: string;
};

export default async function useTimeEdit(request: EditTimeSlots) {
  return GalaService.time.editTimeSlots(request);
}

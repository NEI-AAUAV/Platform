import { useState, useEffect } from "react";
import GalaService from "@/services/GalaService";

export const TimeStatus = {
  OPENING: 0,
  OPEN: 1,
  CLOSED: 2,
};

type TimeExtended = TimeSlots & {
  tablesStatus: number;
  votesStatus: number;
};

const getTimeStatus = (startTime: string, endTime: string) => {
  const openDate = new Date(startTime);
  const closeDate = new Date(endTime);
  const currentDate = new Date();
  currentDate.setHours(currentDate.getHours() - 1);
  if (currentDate < openDate) {
    return TimeStatus.OPENING;
  }
  if (currentDate >= openDate && currentDate <= closeDate) {
    return TimeStatus.OPEN;
  }
  return TimeStatus.CLOSED;
};

export default function useTime() {
  const [time, setTime] = useState<TimeExtended>();

  useEffect(() => {
    (async () => {
      const response = await GalaService.time.getTimeSlots();
      const tablesStatus = getTimeStatus(
        response.tablesStart,
        response.tablesEnd,
      );
      const votesStatus = getTimeStatus(response.votesStart, response.votesEnd);
      setTime({ ...response, tablesStatus, votesStatus });
    })();
  }, []);

  return { time };
}

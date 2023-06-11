import { useState, useEffect } from "react";
import GalaService from "@/services/GalaService";

export default function useTime() {
  const [time, setTime] = useState<TimeSlots>();
  useEffect(() => {
    (async () => {
      const response = await GalaService.time.getTimeSlots();
      setTime(response);
    })();
  }, []);
  return { time };
}

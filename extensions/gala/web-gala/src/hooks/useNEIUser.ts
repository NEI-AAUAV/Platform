import { useState, useEffect } from "react";
import NEIService from "@/services/NEIService";

export default function useNEIUser(id: number | null) {
  const [neiUserId, setNEIUserId] = useState(id);
  const [neiUser, setNEIUser] = useState<NEIUser | null>(null);

  useEffect(() => {
    if (neiUserId === null) {
      return;
    }
    (async () => {
      try {
        const response = await NEIService.getUserById(neiUserId);
        setNEIUser(response);
      } catch (error) {
        console.error(error);
        setNEIUser(null);
      }
    })();
  }, [neiUserId]);

  return { neiUser, setNEIUserId };
}

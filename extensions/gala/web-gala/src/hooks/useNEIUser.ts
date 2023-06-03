import { useState, useEffect } from "react";
import NEIService from "@/services/NEIService";

export default function useNEIUser(id: number | undefined) {
  const [neiUserId, setNEIUserId] = useState(id);
  const [neiUser, setNEIUser] = useState<NEIUser>();

  useEffect(() => {
    if (neiUserId === undefined) {
      return;
    }
    (async () => {
      const response = await NEIService.getUserById(neiUserId);
      setNEIUser(response);
    })();
  }, [neiUserId]);

  return { neiUser, setNEIUserId };
}

import { useState, useEffect } from "react";
import GalaService from "@/services/GalaService";

export default function useSessionUser() {
  const [sessionUser, setSessionUser] = useState<User>();
  useEffect(() => {
    (async () => {
      try {
        const response = await GalaService.user.getSessionUser();
        setSessionUser(response);
      } catch (error) {
        console.error(error);
      }
      const response = await GalaService.user.getSessionUser();
      setSessionUser(response);
    })();
  }, []);
  return { sessionUser };
}

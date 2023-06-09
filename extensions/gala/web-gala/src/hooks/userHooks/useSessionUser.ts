import { useState, useEffect } from "react";
import GalaService from "@/services/GalaService";
import { useGalaUserStore } from "@/stores/useGalaUserStore";

export default function useSessionUser() {
  const [sessionUser, setSessionUser] = useState<User>();
  useEffect(() => {
    (async () => {
      try {
        const response = await GalaService.user.getSessionUser();
        useGalaUserStore.setState(response);
        setSessionUser(response);
      } catch (error) {
        console.error(error);
      }
      // FIXME: why this?
      const response = await GalaService.user.getSessionUser();
      setSessionUser(response);
    })();
  }, []);
  return { sessionUser };
}

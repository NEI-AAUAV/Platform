import { useState, useEffect } from "react";
import GalaService from "@/services/GalaService";

export default function useSessionUser() {
  const [sessionUser, setSessionUser] = useState<User>();
  useEffect(() => {
    (async () => {
      const response = await GalaService.user.getSessionUser();
      setSessionUser(response);
    })();
  }, []);
  return { sessionUser };
}

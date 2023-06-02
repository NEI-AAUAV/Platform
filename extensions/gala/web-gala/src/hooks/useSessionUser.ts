import { useState, useEffect } from "react";
import GalaService from "@/services/GalaService";

export default function useSessionUser() {
  const [sessionUser, setSessionUser] = useState<User>();
  useEffect(() => {
    (async () => {
      const response = await GalaService.getSessionUser();
      const json = response.data;
      setSessionUser(json);
    })();
  }, []);
  return { sessionUser };
}

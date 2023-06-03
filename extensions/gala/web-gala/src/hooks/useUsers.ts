import { useState, useEffect } from "react";
import GalaService from "@/services/GalaService";

export default function useUsers() {
  const [users, setUsers] = useState<User[]>([]);
  useEffect(() => {
    (async () => {
      const response = await GalaService.listUsers();
      setUsers(response);
    })();
  }, []);
  return { users };
}

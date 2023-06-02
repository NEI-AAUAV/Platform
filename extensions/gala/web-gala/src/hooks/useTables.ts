import { useState, useEffect } from "react";
import GalaService from "@/services/GalaService";

export default function useTables() {
  const [tables, setTables] = useState<Table[]>([]);

  useEffect(() => {
    (async () => {
      const response = await GalaService.listTables();
      const json = response.data;
      setTables(json);
    })();
  }, []);

  return { tables };
}

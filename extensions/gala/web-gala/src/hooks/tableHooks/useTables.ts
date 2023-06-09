import { useState, useEffect } from "react";
import GalaService from "@/services/GalaService";
import { useUserStore } from "@/stores/useUserStore";

export default function useTables() {
  const [tables, setTables] = useState<Table[]>([]);
  const sub = useUserStore((state) => state.sub);

  useEffect(() => {
    (async () => {
      let response: Table[] = [];
      if (!sub) {
        response = await GalaService.table.listTablesPublic();
      } else {
        response = await GalaService.table.listTables();
      }
      setTables(response);
    })();
  }, []);

  return { tables };
}

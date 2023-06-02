import { useState, useEffect } from "react";
import GalaService from "@/services/GalaService";

export default function useTables(id: number | undefined) {
  const [tableId, setTableId] = useState(id);
  const [tables, setTables] = useState<Table>();

  useEffect(() => {
    if (tableId === undefined) {
      return;
    }
    (async () => {
      const response = await GalaService.getTable(tableId);
      const json = response.data;
      setTables(json);
    })();
  }, [tableId]);

  return { tables, setTableId };
}

import { useState, useEffect } from "react";
import GalaService from "@/services/GalaService";

export default function useTable(id: number | undefined) {
  const [tableId, setTableId] = useState(id);
  const [table, setTable] = useState<Table | null>();

  useEffect(() => {
    if (!tableId) {
      setTable(undefined);
      return;
    }
    (async () => {
      try {
        const response = await GalaService.table.getTable(tableId);
        setTable(response);
      } catch (error) {
        console.error(error);
        setTable(null);
      }
    })();
  }, [tableId]);

  // useEffect(() => {
  //   console.count("useTable");
  //   if (tableId === undefined) {
  //     setTable(undefined);
  //     return;
  //   }
  //   (async () => {
  //     const response = await GalaService.getTable(tableId);
  //     setTable(response);
  //   })();
  // }, [tableId]);

  return { table, setTableId };
}

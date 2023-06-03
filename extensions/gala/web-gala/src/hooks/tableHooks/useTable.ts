import { useState, useMemo } from "react";
import GalaService from "@/services/GalaService";

export default function useTable(id: number | undefined) {
  const [tableId, setTableId] = useState(id);
  // const [table, setTable] = useState<Table>();

  const table = useMemo(() => {
    console.count("useMemo");
    if (tableId === undefined) {
      return undefined;
    }
    return (async () => {
      const response = await GalaService.table.getTable(tableId);
      return response;
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

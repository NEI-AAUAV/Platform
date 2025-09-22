import React from "react";
import service from "services/NEIService";
import { LOG_PAGE_SIZE } from "../constants";

export default function useArraialHistory(auth) {
  const [log, setLog] = React.useState([]);
  const [logLoading, setLogLoading] = React.useState(false);
  const [nextOffset, setNextOffset] = React.useState(null);
  const [filterNucleo, setFilterNucleo] = React.useState("");
  const [filterRolledBack, setFilterRolledBack] = React.useState("");

  const load = React.useCallback(
    (offset = 0, append = false) => {
      if (!auth) return;
      setLogLoading(true);
      const filters = {};
      if (filterNucleo) filters.nucleo = filterNucleo;
      if (filterRolledBack === "true") filters.rolled_back = true;
      if (filterRolledBack === "false") filters.rolled_back = false;
      service
        .getArraialLog(LOG_PAGE_SIZE, offset, filters)
        .then(({ items, next_offset }) => {
          setLog((prev) => (append ? [...prev, ...(items || [])] : items || []));
          setNextOffset(next_offset ?? null);
        })
        .catch(() => {})
        .finally(() => setLogLoading(false));
    },
    [auth, filterNucleo, filterRolledBack]
  );

  React.useEffect(() => {
    if (!auth) return;
    load(0, false);
  }, [auth, filterNucleo, filterRolledBack, load]);

  return {
    log,
    logLoading,
    nextOffset,
    filterNucleo,
    setFilterNucleo,
    filterRolledBack,
    setFilterRolledBack,
    load,
    setLog,
    setNextOffset,
  };
}

import classNames from "classnames";
import { Link, Navigate, useNavigate, useParams } from "react-router-dom";
import { useEffect, useMemo } from "react";
import TableModal from "../TableModal";
import Table from "@/components/Table";
import useTables from "@/hooks/tableHooks/useTables";
import useTable from "@/hooks/tableHooks/useTable";
import useSessionUser from "@/hooks/userHooks/useSessionUser";
import { useUserStore } from "@/stores/useUserStore";

function useTablePage() {
  const { table, setTableId } = useTable(undefined);
  const { tableId } = useParams();
  const navigate = useNavigate();

  useEffect(() => {
    setTableId(tableId ? Number(tableId) : undefined);

    if (table === null) {
      navigate("/reserve");
    }
  }, [tableId, table]);

  return table || undefined;
}

function calculateOccupiedSeats(persons: Person[]) {
  return persons.reduce((acc, person) => acc + 1 + person.companions.length, 0);
}

export default function Reserve() {
  const { tables } = useTables();
  const tablePage = useTablePage();
  const { sessionLoading, sub } = useUserStore((state) => ({
    sessionLoading: state.sessionLoading,
    sub: state.sub,
  }));
  const { sessionUser } = useSessionUser();
  const inAnyTable = useMemo(
    () => tables.some((t) => t.persons.some((p) => p.id === sessionUser?._id)),
    [tables, sessionUser],
  );

  function linkLocation(table: Table) {
    const occupied = calculateOccupiedSeats(table.persons);

    if (inAnyTable && occupied === 0) {
      return "";
    }
    return `/reserve/${table._id}`;
  }

  return (
    <>
      <h2 className="m-20 text-center text-2xl font-bold">
        Escolhe a tua mesa.
      </h2>
      <div className="m-10 grid grid-cols-[repeat(auto-fit,_minmax(13.25rem,_1fr))] gap-14">
        {tables?.map((table) => (
          <Link
            key={table._id}
            to={linkLocation(table)}
            className={classNames({
              "cursor-default": linkLocation(table) === "",
            })}
          >
            <Table table={table} />
          </Link>
        ))}
      </div>
      {!sessionLoading && sub === undefined && <Navigate to="/" />}
      {tablePage !== undefined && <TableModal table={tablePage} />}
    </>
  );
}

import classNames from "classnames";
import { Link, useParams } from "react-router-dom";
import { useMemo } from "react";
import TableModal from "../TableModal";
import Table from "@/components/Table";
import useTables from "@/hooks/tableHooks/useTables";
import useSessionUser, { State } from "@/hooks/userHooks/useSessionUser";
import useLoginLink from "@/hooks/useLoginLink";

function calculateOccupiedSeats(persons: Person[]) {
  return persons.reduce((acc, person) => acc + 1 + person.companions.length, 0);
}

export default function Reserve() {
  const { tableId } = useParams();
  const { tables, isLoading } = useTables();
  const { sessionUser, state } = useSessionUser();
  const inAnyTable = useMemo(() => {
    if (isLoading) return false;
    return tables.some((t) => t.persons.some((p) => p.id === sessionUser?._id));
  }, [tables, sessionUser, isLoading]);
  const loginLink = useLoginLink();

  function linkLocation(table: Table) {
    const occupied = calculateOccupiedSeats(table.persons);

    if (state !== State.REGISTERED || (inAnyTable && occupied === 0)) {
      return "";
    }
    return `/reserve/${table._id}`;
  }

  const header = {
    [State.NONE]: {
      text: "Inicia sessão para escolheres a tua mesa.",
      label: "Iniciar sessão",
      link: loginLink,
    },
    [State.AUTHENTICATED]: {
      text: "Efetua a inscrição para escolheres a tua mesa.",
      label: "Efetuar inscrição",
      link: "/register",
    },
    [State.REGISTERED]: {
      text: "Escolhe a tua mesa.",
    },
  };

  return (
    <>
      <h2 className="m-20 text-center text-2xl font-bold">
        <span className="block">{header[state].text}</span>
        {header[state].link && (
          <Link
            className="btn-md btn mb-8 mt-4 rounded-full bg-black/70 font-bold normal-case text-white backdrop-blur sm:text-[1.25rem]"
            to={header[state].link || ""}
          >
            {header[state].label}
          </Link>
        )}
      </h2>
      <div className="m-10 grid grid-cols-[repeat(auto-fit,_minmax(13.25rem,_1fr))] gap-14">
        {tables?.map((table) => {
          const location = linkLocation(table);

          return (
            <Link
              key={table._id}
              to={location}
              className={classNames({
                "cursor-default": state !== State.REGISTERED,
              })}
            >
              <Table table={table} />
            </Link>
          );
        })}
      </div>
      {tableId !== undefined && <TableModal tableId={Number(tableId)} />}
    </>
  );
}

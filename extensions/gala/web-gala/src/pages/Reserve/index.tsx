import { Link, useParams } from "react-router-dom";
import TableModal from "../TableModal";
import Table from "@/components/Table";
import useTables from "@/hooks/tableHooks/useTables";
import useSessionUser, { State } from "@/hooks/userHooks/useSessionUser";
import useLoginLink from "@/hooks/useLoginLink";
import useTime, { TimeStatus } from "@/hooks/timeHooks/useTime";

export default function Reserve() {
  const { tableId } = useParams();
  const { tables } = useTables();
  const { state } = useSessionUser();
  const { time } = useTime();

  const loginLink = useLoginLink();

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
      {time?.tablesStatus === TimeStatus.OPEN ? (
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
      ) : (
        <h2 className="m-20 text-center text-2xl font-bold">
          Reserva de mesas fechada.
        </h2>
      )}
      <div className="m-10 grid grid-cols-[repeat(auto-fit,_minmax(13.25rem,_1fr))] gap-14">
        {tables?.map((table) => {
          const location = `/reserve/${table._id}`;

          return (
            <Link key={table._id} to={location}>
              <Table table={table} />
            </Link>
          );
        })}
      </div>
      {tableId !== undefined && <TableModal tableId={Number(tableId)} />}
    </>
  );
}

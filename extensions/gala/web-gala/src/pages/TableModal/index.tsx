import { faXmark } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useEffect, useRef } from "react";
import { Link, Navigate, useNavigate } from "react-router-dom";
import classNames from "classnames";
import { AnimatePresence, motion } from "framer-motion";
import useSessionUser, { State } from "@/hooks/userHooks/useSessionUser";
import useTime, { TimeStatus } from "@/hooks/timeHooks/useTime";
import useTables from "@/hooks/tableHooks/useTables";
import useTable from "@/hooks/tableHooks/useTable";
import RequestJoinTable from "./RequestJoinTable";
import EditTable from "./EditTable";
import ViewTable from "./ViewTable";
import ClaimTable from "./ClaimTable";

type TableModalProps = {
  tableId: number;
};

function calculateOccupiedSeats(persons: Person[]) {
  return persons.reduce((acc, person) => acc + 1 + person.companions.length, 0);
}

function getModalPage(tableId: number) {
  const { table, isLoading, mutate } = useTable(tableId);

  useEffect(() => {
    if (!isLoading) mutate();
  }, []);

  if (isLoading) return null;
  if (table === undefined) return <Navigate to="/reserve" />;

  const { tables } = useTables();
  const { sessionUser, state } = useSessionUser();
  const { time } = useTime();
  const occupied = calculateOccupiedSeats(table.persons);

  const inAnyTable = tables.some((t) =>
    t.persons.some((p) => p.id === sessionUser?._id),
  );

  const inTable = table.persons.some((p) => p.id === sessionUser?._id);

  if (!time) return null;

  if (state !== State.REGISTERED || time?.tablesStatus !== TimeStatus.OPEN) {
    return <ViewTable table={table} inTable={false} mutate={mutate} />;
  }
  if (occupied === 0 && !inAnyTable) {
    return <ClaimTable table={table} mutate={mutate} />;
  }
  if (String(table.head) === sessionUser.sub) {
    return <EditTable table={table} mutate={mutate} />;
  }
  if (inAnyTable && occupied > 0) {
    return <ViewTable table={table} inTable={inTable} mutate={mutate} />;
  }
  if (String(table.head) !== sessionUser.sub && !inAnyTable) {
    return <RequestJoinTable table={table} mutate={mutate} />;
  }
  // wtf is this
  return <ViewTable table={table} inTable={false} mutate={mutate} />;
}

function useModal() {
  const modalRef = useRef<HTMLDialogElement>(null);

  useEffect(() => {
    if (modalRef.current) {
      modalRef.current.showModal();
      document.body.style.overflow = "hidden";
    }
    return () => {
      modalRef.current?.close();
      document.body.style.overflow = "auto";
    };
  }, []);

  return modalRef;
}

export default function TableModal({ tableId }: TableModalProps) {
  const modalRef = useModal();
  const navigate = useNavigate();
  const modalPage = getModalPage(tableId);

  useEffect(() => {
    function cancelHandler(e: Event) {
      e.preventDefault();
    }

    modalRef.current?.addEventListener("cancel", cancelHandler);
    return () => {
      modalRef.current?.removeEventListener("cancel", cancelHandler);
    };
  }, []);

  return (
    <dialog
      ref={modalRef}
      className={classNames(
        "relative m-0 grid h-screen max-h-none w-screen max-w-none items-center overflow-y-scroll bg-transparent p-0 text-base-content/70 backdrop:bg-black/50",
        // !modalPage && "hidden",
      )}
    >
      <AnimatePresence>
        {!!modalPage && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="relative z-10 my-16 rounded-3xl bg-base-100 px-4 py-12 sm:px-12 md:mx-auto md:h-auto"
          >
            <button
              className="absolute right-4 top-4 leading-none"
              type="button"
              onClick={() => navigate("/reserve")}
            >
              <FontAwesomeIcon icon={faXmark} />
            </button>
            {modalPage}
          </motion.div>
        )}
      </AnimatePresence>
      <Link className="absolute inset-0 -z-10" to="/reserve" />
    </dialog>
  );
}

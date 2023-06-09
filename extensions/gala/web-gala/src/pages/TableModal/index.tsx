/* eslint-disable jsx-a11y/click-events-have-key-events */
/* eslint-disable jsx-a11y/no-noninteractive-element-interactions */
import { faXmark } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { lazy, useEffect, useRef } from "react";
import { Link, Navigate, useNavigate } from "react-router-dom";
import RequestJoinTable from "./RequestJoinTable";
import { useUserStore } from "@/stores/useUserStore";
import EditTable from "./EditTable";
import useSessionUser from "@/hooks/userHooks/useSessionUser";
import useTables from "@/hooks/tableHooks/useTables";
import ViewTable from "./ViewTable";
import useTable from "@/hooks/tableHooks/useTable";

const ClaimTable = lazy(() => import("./ClaimTable"));

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
  const { sessionUser } = useSessionUser();
  const occupied = calculateOccupiedSeats(table.persons);
  const currentUserId = useUserStore((state) => state?.sub);

  const inAnyTable = tables.some((t) =>
    t.persons.some((p) => p.id === sessionUser?._id),
  );

  const inTable = table.persons.some((p) => p.id === sessionUser?._id);

  if (occupied === 0 && !inAnyTable) {
    return <ClaimTable table={table} mutate={mutate} />;
  }

  if (String(table.head) === currentUserId) {
    return <EditTable table={table} mutate={mutate} />;
  }
  if (inAnyTable && occupied > 0) {
    return <ViewTable table={table} inTable={inTable} mutate={mutate} />;
  }

  if (String(table.head) !== currentUserId && !inAnyTable) {
    return <RequestJoinTable table={table} mutate={mutate} />;
  }

  // wtf is this
  return <Navigate to="/reserve" />;
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

  return (
    <dialog
      ref={modalRef}
      className="flex h-screen max-h-none w-screen max-w-none items-center justify-center overflow-y-scroll bg-transparent p-0 backdrop:bg-black/50"
    >
      <div className="relative z-10 m-10 w-full rounded-3xl bg-base-100 p-6 sm:max-w-3xl">
        <button
          className="absolute right-4 top-4 leading-none"
          type="button"
          onClick={() => navigate("/reserve")}
        >
          <FontAwesomeIcon icon={faXmark} />
        </button>
        {modalPage}
      </div>
      <Link className="absolute inset-0 -z-10" to="/reserve" />
    </dialog>
  );
}

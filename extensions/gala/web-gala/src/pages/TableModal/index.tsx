/* eslint-disable jsx-a11y/click-events-have-key-events */
/* eslint-disable jsx-a11y/no-noninteractive-element-interactions */
import { lazy, useEffect, useRef } from "react";
import { Link } from "react-router-dom";
import RequestJoinTable from "./RequestJoinTable";
import { useUserStore } from "@/stores/useUserStore";
import EditTable from "./EditTable";

const ClaimTable = lazy(() => import("./ClaimTable"));

type TableModalProps = {
  table: Table;
};

function calculateOccupiedSeats(persons: Person[]) {
  return persons.reduce((acc, person) => acc + 1 + person.companions.length, 0);
}

function getModalPage(table: Table) {
  const currentUserId = useUserStore((state) => state?.sub);
  const occupied = calculateOccupiedSeats(table.persons);

  if (occupied === 0) {
    return <ClaimTable table={table} />;
  }

  if (String(table.head) === currentUserId) {
    return <EditTable table={table} />;
  }

  if (String(table.head) !== currentUserId) {
    return <RequestJoinTable table={table} />;
  }

  // wtf is this
  return <div id="na" />;
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

export default function TableModal({ table }: TableModalProps) {
  const modalPage = getModalPage(table);
  const modalRef = useModal();

  return (
    <dialog
      ref={modalRef}
      className="flex h-screen max-h-none w-screen max-w-none items-center justify-center overflow-y-scroll bg-transparent p-0 backdrop:bg-black/50"
    >
      <div className="z-10 m-10 w-full rounded-3xl bg-base-100 p-6">
        {modalPage}
      </div>
      <Link className="absolute inset-0 -z-10" to="/reserve" />
    </dialog>
  );
}

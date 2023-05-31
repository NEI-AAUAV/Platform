/* eslint-disable jsx-a11y/click-events-have-key-events */
/* eslint-disable jsx-a11y/no-noninteractive-element-interactions */
import { MouseEvent, MouseEventHandler, lazy, useEffect, useRef } from "react";
import { Link, useNavigate } from "react-router-dom";
import RequestJoinTable from "./RequestJoinTable";

const ClaimTable = lazy(() => import("./ClaimTable"));

type TableModalProps = {
  table: Table;
};

function calculateOccupiedSeats(persons: Person[]) {
  return persons.reduce((acc, person) => acc + 1 + person.companions.length, 0);
}

function getModalPage(table: Table) {
  const occupied = calculateOccupiedSeats(table.persons);

  if (occupied === 0) {
    return <ClaimTable table={table} />;
  }
  // TODO: this is just to debug the request join table page
  if (table._id === 1) {
    return <RequestJoinTable table={table} />;
  }
  // wtf is this
  return <div id="na" />;
}

function isClickOutside(
  event: MouseEvent<HTMLDialogElement>,
  element: HTMLDialogElement | null,
) {
  const rect = element?.getBoundingClientRect();
  if (!rect) return false;
  return (
    event.clientX < rect.left ||
    event.clientX > rect.right ||
    event.clientY < rect.top ||
    event.clientY > rect.bottom
  );
}

export default function TableModal({ table }: TableModalProps) {
  const navigate = useNavigate();
  const modalPage = getModalPage(table);
  const modalRef = useRef<HTMLDialogElement>(null);

  const handleClickOutside: MouseEventHandler<HTMLDialogElement> = (
    event: MouseEvent<HTMLDialogElement>,
  ) => {
    if (isClickOutside(event, modalRef.current)) {
      navigate("/reserve");
    }
  };

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

  return (
    <dialog
      ref={modalRef}
      className="h-full w-full bg-transparent p-6 backdrop:bg-black/50"
      onClick={handleClickOutside}
    >
      <div className="z-10 h-full w-full rounded-3xl bg-base-100 p-6">
        {modalPage}
      </div>
      <Link className="absolute inset-0 -z-10" to="/reserve" />
    </dialog>
    // <div className="fixed top-0 z-50 flex h-full w-full justify-center">
    //   <div className="m-10 w-full rounded-3xl bg-base-100 p-6 shadow-lg">
    //     {modalPage}
    //   </div>
    //   {/* <Link className="absolute inset-0" to="/reserve" /> */}
    // </div>
  );
}

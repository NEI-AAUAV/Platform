import { lazy } from "react";

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
  return <div id="na" />;
}

export default function TableModal({ table }: TableModalProps) {
  const modalPage = getModalPage(table);

  return (
    <div className="absolute inset-0 z-50 flex items-center justify-center bg-black/50">
      <div className="m-10 w-full rounded-3xl bg-base-100 p-6 shadow-lg">
        {modalPage}
      </div>
    </div>
  );
}

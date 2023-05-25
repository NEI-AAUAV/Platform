import VisualTable from "./VisualTable";

type TableProps = {
  table: Table;
  className?: string;
};

function calculateOccupiedSeats(persons: Person[]) {
  return persons.reduce((acc, person) => acc + 1 + person.companions.length, 0);
}

export default function Table({ table, className }: TableProps) {
  const { name, head, seats, persons } = table;
  const occupiedSeats = calculateOccupiedSeats(persons);
  return (
    <div className={`flex flex-col items-center ${className}`}>
      <h4 className="font-semibold text-xl z-10">{name}</h4>
      <h6 className="font-light text-sm uppercase z-10">{head}</h6>
      <VisualTable seats={seats} occupiedSeats={occupiedSeats} />
    </div>
  );
}

Table.defaultProps = {
  className: "",
};

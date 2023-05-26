import VisualTable from "./VisualTable";

type TableProps = {
  table: Table;
  className?: string;
};

function calculateOccupiedSeats(persons: Person[]) {
  return persons.reduce((acc, person) => acc + 1 + person.companions.length, 0);
}

// TODO! Leandro se vires isto faz me o modal
export default function Table({ table, className }: TableProps) {
  const { name, head, seats, persons } = table;
  const occupiedSeats = calculateOccupiedSeats(persons);
  return (
    <div className={`flex flex-col items-center ${className}`}>
      <h4 className="z-10 text-xl font-semibold">{name}</h4>
      <h6 className="z-10 text-sm font-light uppercase">{head}</h6>
      <VisualTable seats={seats} occupiedSeats={occupiedSeats} />
    </div>
  );
}

Table.defaultProps = {
  className: "",
};

import VisualTable from "./VisualTable";

type Person = {
  id: number;
  allergies: string;
  dish: string;
  confirmed: boolean;
  companions: {
    dish: string;
    allergies: string;
  }[];
};

type TableProps = {
  table: {
    _id: number;
    name: string;
    head: string;
    seats: number;
    persons: Person[];
  };
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

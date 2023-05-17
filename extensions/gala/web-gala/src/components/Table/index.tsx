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
    persons: {
      id: number;
      allergies: string;
      dish: string;
      confirmed: boolean;
      companions: {
        dish: string;
        allergies: string;
      }[];
    }[];
  };
  className?: string;
};

function calculateOccupiedSeats(persons: Person[]) {
  let occupiedSeats = 0;
  persons.forEach((person) => {
    occupiedSeats += 1;
    if (person.companions.length > 0) {
      occupiedSeats += person.companions.length;
    }
  });
  return occupiedSeats;
}

export default function Table({ table, className }: TableProps) {
  const { name, head, seats, persons } = table;
  const occupiedSeats = calculateOccupiedSeats(persons);
  return (
    <div className={`flex flex-col items-center ${className}`}>
      <h4>{name}</h4>
      <h6>{head}</h6>
      <VisualTable seats={seats} occupiedSeats={occupiedSeats} />
    </div>
  );
}

Table.defaultProps = {
  className: "",
};

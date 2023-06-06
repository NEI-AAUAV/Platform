import AddUserList from "@/components/TableModal/AddUserList";

type RequestFormProps = {
  table: Table;
};
function calculateOccupiedSeats(persons: Person[]) {
  return persons.reduce((acc, person) => acc + 1 + person.companions.length, 0);
}
export default function RequestForm({ table }: RequestFormProps) {
  return (
    <AddUserList
      freeSeats={table.seats - calculateOccupiedSeats(table.persons)}
    />
  );
}

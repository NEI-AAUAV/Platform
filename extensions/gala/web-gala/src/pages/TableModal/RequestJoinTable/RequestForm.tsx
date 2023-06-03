import { faPaperPlane } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import Button from "@/components/Button";
import AddUserList from "@/components/TableModal/AddUserList";

type RequestFormProps = {
  table: Table;
};
function calculateOccupiedSeats(persons: Person[]) {
  return persons.reduce((acc, person) => acc + 1 + person.companions.length, 0);
}
export default function RequestForm({ table }: RequestFormProps) {
  return (
    <form className="flex h-full flex-col">
      <AddUserList
        freeSeats={table.seats - calculateOccupiedSeats(table.persons)}
      />
      <Button className="mt-auto">
        <FontAwesomeIcon icon={faPaperPlane} /> Enviar Convite
      </Button>
    </form>
  );
}

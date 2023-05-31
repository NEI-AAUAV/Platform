import { faChair } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import Button from "@/components/Button";
import GuestList from "@/components/TableModal/GuestList";

type ViewTableProps = {
  persons: Person[];
  onClick: () => void;
};

export default function ViewTable({ persons, onClick }: ViewTableProps) {
  return (
    <>
      <GuestList persons={persons} />
      <Button className="mt-auto" onClick={onClick}>
        <FontAwesomeIcon icon={faChair} /> Pedir convite para esta mesa
      </Button>
    </>
  );
}

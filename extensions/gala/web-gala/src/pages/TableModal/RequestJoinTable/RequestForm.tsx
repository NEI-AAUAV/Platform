import { faPaperPlane } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import Button from "@/components/Button";
import AddUserList from "@/components/TableModal/AddUserList";

export default function RequestForm() {
  return (
    <form className="flex h-full flex-col">
      <AddUserList />
      <Button className="mt-auto">
        <FontAwesomeIcon icon={faPaperPlane} /> Enviar Convite
      </Button>
    </form>
  );
}

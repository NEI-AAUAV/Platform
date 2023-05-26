import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faPaperPlane } from "@fortawesome/free-solid-svg-icons";
import Table from "@/components/Table";
import GuestList from "./GuestList";

type TableModalProps = {
  table: Table;
  className?: string;
};

export default function TableModal({ table, className }: TableModalProps) {
  const type = {
    free: <>ola</>,
    occupied: <>ola</>,
    owner: <>ola</>,
    guest: <>ola</>,
  };

  return (
    <div className={`rounded-3xl bg-base-100 p-4 shadow-lg  ${className}`}>
      <Table table={table} />
      <h3 className="text-xl font-semibold">Convidad@s</h3>
      <GuestList persons={table.persons} />
      <button
        type="button"
        className="rounded-3xl bg-gradient-to-tr from-dark-gold to-light-gold px-4 py-2 font-semibold"
      >
        <FontAwesomeIcon icon={faPaperPlane} /> Enviar Convite
      </button>
    </div>
  );
}

TableModal.defaultProps = {
  className: "",
};

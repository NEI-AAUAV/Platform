import { faPen } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import VisualTable from "@/components/Table/VisualTable";
import GuestList from "@/components/TableModal/GuestList";
import AcceptPending from "./AcceptPending";

type EditTableProps = {
  table: Table;
};

export default function EditTable({ table }: EditTableProps) {
  return (
    <div className="flex flex-col items-center gap-3">
      <span className="flex gap-3">
        <h1 className="text-3xl font-bold">{table.name}</h1>
        <button type="button">
          <FontAwesomeIcon icon={faPen} />
        </button>
      </span>
      <h5>És o dono desta mesa</h5>
      <VisualTable table={table} />
      <GuestList persons={table.persons} />
      <AcceptPending persons={table.persons} />
    </div>
  );
}

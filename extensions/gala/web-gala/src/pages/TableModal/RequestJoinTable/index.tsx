import { faPaperPlane, faChair } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useState } from "react";
import Avatar from "@/components/Avatar";
import VisualTable from "@/components/Table/VisualTable";
import RequestForm from "./RequestForm";
import Button from "@/components/Button";
import useNEIUser from "@/hooks/useNEIUser";
import GuestList from "@/components/TableModal/GuestList";

type RequestJoinTableProps = {
  table: Table;
};

export default function RequestJoinTable({ table }: RequestJoinTableProps) {
  const [form, setForm] = useState(false);
  const { neiUser } = useNEIUser(table.head);

  return (
    <div className="items-center sm:flex">
      <form className="flex flex-col items-center gap-3">
        <div className="flex flex-col items-center gap-3 overflow-y-scroll px-3 sm:w-full sm:items-start">
          <h1 className="text-3xl font-bold">{table.name}</h1>
          <div className="mb-10 flex items-center gap-3">
            <Avatar id={table.head} className="w-[18px]" />
            <h6 className="capitalize">{`${neiUser?.name} ${neiUser?.surname}`}</h6>
          </div>
          <VisualTable className="sm:hidden" table={table} />
          {form ? (
            <RequestForm table={table} />
          ) : (
            <GuestList persons={table.persons} />
          )}
        </div>
        {form ? (
          <Button className="sticky bottom-0 mt-4 w-full">
            <FontAwesomeIcon icon={faPaperPlane} /> Enviar Convite
          </Button>
        ) : (
          <Button className="mt-4 w-full" onClick={() => setForm(true)}>
            <FontAwesomeIcon icon={faChair} /> Pedir convite para esta mesa
          </Button>
        )}
      </form>
      <VisualTable className="ml-auto mr-20 hidden sm:block" table={table} />
    </div>
  );
}

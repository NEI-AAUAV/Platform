import { useRef } from "react";
import { faPen } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import VisualTable from "@/components/Table/VisualTable";
import GuestList from "@/components/TableModal/GuestList";
import AcceptPending from "./AcceptPending";
import useTableEdit from "@/hooks/tableHooks/useTableEdit";
import Avatar from "@/components/Avatar";

type EditTableProps = {
  table: Table;
};

export default function EditTable({ table }: EditTableProps) {
  const titleRef = useRef<HTMLTextAreaElement>(null);
  return (
    <div className="items-center sm:flex">
      <div className="flex flex-col items-center gap-3 sm:items-start">
        <span className="flex gap-3 sm:max-w-[18rem]">
          <textarea
            rows={1}
            className="block w-80 select-none resize-none overflow-hidden rounded-3xl px-4 py-2 text-3xl font-bold focus:border-transparent focus:outline-none focus:ring-2 focus:ring-light-gold"
            readOnly
            placeholder="Sem nome"
            defaultValue={table.name ?? ""}
            onDoubleClick={() => {
              titleRef.current!.readOnly = false;
              titleRef.current?.focus();
            }}
            onFocus={() => {
              if (titleRef.current?.readOnly) titleRef.current?.blur();
            }}
            onBlur={() => {
              useTableEdit(table._id, { name: titleRef.current?.value ?? "" });
              titleRef.current!.readOnly = true;
            }}
            onInput={() => {
              titleRef.current!.style.setProperty("height", "auto");
              titleRef.current?.style.setProperty(
                "height",
                `${titleRef.current.scrollHeight}px`,
              );
            }}
            ref={titleRef}
          />
          <button
            type="button"
            onClick={() => {
              titleRef.current!.readOnly = false;
              titleRef.current?.focus();
            }}
          >
            <FontAwesomeIcon icon={faPen} />
          </button>
        </span>
        <h5 className="sm:mb-10">
          <Avatar className="w-[1.125rem]" /> És o dono desta mesa
        </h5>
        <VisualTable className="sm:hidden" table={table} />
        <GuestList persons={table.persons} />
        <AcceptPending persons={table.persons} />
      </div>
      <VisualTable className="ml-auto mr-20 hidden sm:block" table={table} />
    </div>
  );
}

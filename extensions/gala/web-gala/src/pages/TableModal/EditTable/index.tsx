import { useNavigate } from "react-router-dom";
import { useEffect, useRef, useState } from "react";
import { faPen } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import VisualTable from "@/components/Table/VisualTable";
import GuestList from "@/components/TableModal/GuestList";
import AcceptPending from "./AcceptPending";
import useTableEdit from "@/hooks/tableHooks/useTableEdit";
import Avatar from "@/components/Avatar";
import Button from "@/components/Button";
import useTableLeave from "@/hooks/tableHooks/useTableLeave";

type EditTableProps = {
  table: Table;
  mutate: () => void;
};

export default function EditTable({ table, mutate }: EditTableProps) {
  const titleRef = useRef<HTMLTextAreaElement>(null);
  const [error, setError] = useState(false);
  const navigate = useNavigate();
  useEffect(() => {
    if (titleRef.current?.value === undefined) return;
    titleRef.current!.style.setProperty(
      "width",
      `${titleRef.current!.scrollWidth}px`,
    );
    titleRef.current!.style.setProperty(
      "height",
      `${titleRef.current!.scrollHeight}px`,
    );
  }, []);
  return (
    <div className="h-full md:grid md:grid-cols-[1fr_min-content] md:gap-8">
      <div className="flex h-full flex-col items-center gap-8 md:items-start">
        <div>
          <span className="flex gap-2">
            <textarea
              rows={1}
              className="block w-full max-w-[18rem] select-none resize-none overflow-hidden rounded-3xl py-2 text-3xl font-bold focus:border-transparent focus:outline-none focus:ring-2 focus:ring-light-gold"
              readOnly
              placeholder="Sem nome"
              defaultValue={table.name ?? ""}
              onDoubleClick={() => {
                titleRef.current!.readOnly = false;
                titleRef.current?.focus();
              }}
              onFocus={() => {
                if (titleRef.current?.readOnly) titleRef.current?.blur();
                titleRef.current!.classList.add("px-4");
                // titleRef.current!.style.setProperty("width", "100%");
              }}
              onBlur={() => {
                // titleRef.current!.style.setProperty(
                //   "width",
                //   `${titleRef.current!.scrollWidth}px`,
                // );
                titleRef.current!.classList.remove("px-4");
                if (
                  titleRef.current?.value === undefined ||
                  titleRef.current?.value.length < 3 ||
                  titleRef.current?.value.length > 20
                ) {
                  setError(true);
                  return;
                }

                setError(false);

                // Skip editing if the value didn't change
                if (titleRef.current?.value === table.name) return;

                useTableEdit(table._id, {
                  name: titleRef.current?.value ?? "",
                }).then(mutate);
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
          {error && (
            <div className="text-xs text-red-500">
              O nome da mesa deve ter entre 3 a 20 caracteres
            </div>
          )}
          <h5 className="mt-2 flex items-center gap-2">
            <Avatar className="w-[1.125rem]" /> És o dono desta mesa
          </h5>
        </div>
        <VisualTable className="w-min md:hidden" table={table} />
        <GuestList persons={table.persons} />
        <AcceptPending
          persons={table.persons}
          tableId={table._id}
          mutate={mutate}
        />
        <Button
          className="mt-auto w-full"
          onClick={async () => {
            await useTableLeave(table._id);
            mutate();
            navigate("/reserve");
          }}
        >
          Leave Table
        </Button>
      </div>
      <div className="flex items-center justify-center">
        <VisualTable className="hidden md:block" table={table} />
      </div>
    </div>
  );
}

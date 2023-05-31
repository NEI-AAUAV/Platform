import { useState } from "react";
import Avatar from "@/components/Avatar";
import VisualTable from "@/components/Table/VisualTable";
import RequestForm from "./RequestForm";
import ViewTable from "./ViewTable";

type RequestJoinTableProps = {
  table: Table;
};

export default function RequestJoinTable({ table }: RequestJoinTableProps) {
  const [form, setForm] = useState(false);

  return (
    <div className="flex h-full flex-col items-center gap-10">
      <h1 className="text-3xl font-bold">{table.name}</h1>
      <div className="flex items-center gap-3">
        <Avatar className="w-5" />
        <h6 className="capitalize">{table.head}</h6>
      </div>
      <VisualTable table={table} />
      {form ? (
        <RequestForm />
      ) : (
        <ViewTable persons={table.persons} onClick={() => setForm(true)} />
      )}
    </div>
  );
}

import { useNavigate } from "react-router-dom";
import Avatar from "@/components/Avatar";
import Button from "@/components/Button";
import VisualTable from "@/components/Table/VisualTable";
import GuestList from "@/components/TableModal/GuestList";
import useTableLeave from "@/hooks/tableHooks/useTableLeave";
import useNEIUser from "@/hooks/useNEIUser";

type ViewTableProps = {
  table: Table;
  inTable?: boolean;
};
export default function ViewTable({ table, inTable }: ViewTableProps) {
  const { neiUser } = useNEIUser(table.head);
  const navigate = useNavigate();
  return (
    <div className="items-center sm:flex">
      <div className="flex flex-col items-center gap-3">
        <div className="flex flex-col items-center gap-3 overflow-y-scroll px-3 sm:w-full sm:items-start">
          <h1 className="text-3xl font-bold">{table.name}</h1>
          <div className="mb-10 flex items-center gap-3">
            <Avatar id={table.head} className="w-[18px]" />
            <h6 className="capitalize">{`${neiUser?.name} ${neiUser?.surname}`}</h6>
          </div>
          <VisualTable className="sm:hidden" table={table} />
          <GuestList persons={table.persons} />
          {inTable && (
            <Button
              onClick={async () => {
                await useTableLeave(table._id);
                navigate("/reserve");
                navigate(0);
              }}
            >
              Leave Table
            </Button>
          )}
        </div>
      </div>
      <VisualTable className="ml-auto mr-20 hidden sm:block" table={table} />
    </div>
  );
}

ViewTable.defaultProps = {
  inTable: false,
};

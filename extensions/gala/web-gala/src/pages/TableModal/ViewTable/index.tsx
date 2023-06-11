import { useNavigate } from "react-router-dom";
import Avatar from "@/components/Avatar";
import Button from "@/components/Button";
import VisualTable from "@/components/Table/VisualTable";
import GuestList from "@/components/TableModal/GuestList";
import useTableLeave from "@/hooks/tableHooks/useTableLeave";
import useNEIUser from "@/hooks/useNEIUser";

type ViewTableProps = {
  table: Table;
  mutate: () => void;
  inTable?: boolean;
};
export default function ViewTable({ table, inTable, mutate }: ViewTableProps) {
  const { neiUser } = useNEIUser(table.head);
  const navigate = useNavigate();
  return (
    <div className="md:grid md:h-full md:grid-cols-[1fr_min-content] md:gap-8">
      <div className="flex flex-col items-center gap-3">
        <div className="flex flex-col items-center gap-3 overflow-y-scroll px-3 md:items-start">
          <h1 className="text-3xl font-bold">{table.name}</h1>
          <div className="mb-10 flex items-center gap-3">
            <h6 className="flex items-center gap-1 capitalize">
              <Avatar id={table.head} className="w-[18px]" />
              {`${neiUser?.name} ${neiUser?.surname}`}
            </h6>
          </div>
          <VisualTable className="md:hidden" table={table} />
          <GuestList persons={table.persons} />
          {inTable && (
            <Button
              className="w-full"
              onClick={async () => {
                await useTableLeave(table._id);
                mutate();
                navigate("/reserve");
              }}
            >
              Leave Table
            </Button>
          )}
        </div>
      </div>
      <div className="flex items-center justify-center">
        <VisualTable className="hidden md:block" table={table} />
      </div>
    </div>
  );
}

ViewTable.defaultProps = {
  inTable: false,
};

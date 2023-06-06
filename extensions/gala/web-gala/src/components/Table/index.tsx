import Avatar from "../Avatar";
import VisualTable from "./VisualTable";
import useNEIUser from "@/hooks/useNEIUser";

type TableProps = {
  table: Table;
  className?: string;
};

export default function Table({ table, className }: TableProps) {
  const { name, head } = table;
  const { neiUser } = useNEIUser(head);
  return (
    <div className={`flex flex-col items-center ${className}`}>
      <h4 className="z-10 text-xl font-semibold">{name ?? "Mesa sem nome"}</h4>
      <h6 className="z-10 mb-6 text-sm font-light uppercase">
        {head !== null && <Avatar id={head} className="w-4" />}{" "}
        {neiUser?.name === undefined || neiUser?.surname === undefined
          ? "Sem nome"
          : `${neiUser.name} ${neiUser.surname}`}
      </h6>
      <VisualTable table={table} />
    </div>
  );
}

Table.defaultProps = {
  className: "",
};

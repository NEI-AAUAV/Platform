import VisualTable from "./VisualTable";

type TableProps = {
  table: Table;
  className?: string;
};

// TODO! Leandro se vires isto faz me o modal
export default function Table({ table, className }: TableProps) {
  const { name, head } = table;
  return (
    <div className={`flex flex-col items-center ${className}`}>
      <h4 className="z-10 text-xl font-semibold">{name}</h4>
      <h6 className="z-10 mb-6 text-sm font-light uppercase">{head}</h6>
      <VisualTable table={table} />
    </div>
  );
}

Table.defaultProps = {
  className: "",
};

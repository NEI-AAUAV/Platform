import Table from "@/components/Table";

type TableModalProps = {
  table: Table;
  className?: string;
};

export default function TableModal({ table, className }: TableModalProps) {
  return (
    <div className={`bg-base-100 rounded-3xl ${className}`}>
      <Table table={table} />
    </div>
  );
}

TableModal.defaultProps = {
  className: "",
};

import VisualTable from "./VisualTable";

type TableProps = {
  tableName?: string;
  ownerName?: string;
  occupiedSeats?: number;
  className?: string;
};

export default function Table({
  tableName,
  ownerName,
  occupiedSeats,
  className,
}: TableProps) {
  return (
    <div className={`flex flex-col items-center ${className}`}>
      <h4>{tableName}</h4>
      <h6>{ownerName}</h6>
      <VisualTable occupiedSeats={occupiedSeats ?? 0} />
    </div>
  );
}

Table.defaultProps = {
  tableName: "Mesa sem nome",
  ownerName: "SEM DONO",
  occupiedSeats: 0,
  className: "",
};

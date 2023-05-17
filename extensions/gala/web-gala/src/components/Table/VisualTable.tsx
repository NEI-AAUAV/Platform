type VisualTableProps = {
  occupiedSeats: number;
};

export default function VisualTable({ occupiedSeats }: VisualTableProps) {
  const maxSeats = 8;
  return (
    <h1 className="bold">
      Hi this is the visual table representation with {occupiedSeats} seats
    </h1>
  );
}

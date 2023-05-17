type VisualTableProps = {
  seats: number;
  occupiedSeats: number;
};

export default function VisualTable({
  seats,
  occupiedSeats,
}: VisualTableProps) {
  return (
    <h1 className="bold">
      Seats: {seats} with {occupiedSeats} seats occupied
    </h1>
  );
}

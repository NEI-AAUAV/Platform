import Seat from "./Seat";

type VisualTableProps = {
  seats: number;
  occupiedSeats: number;
};

function generateSeats(seats: number, occupiedSeats: number) {
  const arrayOfSeats = [];

  const angleVariation = (2 * Math.PI) / seats;
  const initialAngle = Math.PI / 2;

  for (let i = 0; i < seats; i++) {
    const isTaken = occupiedSeats > i;
    const angle = initialAngle - i * angleVariation;

    arrayOfSeats.push(<Seat isTaken={isTaken} angle={angle} />);
  }
  return arrayOfSeats;
}

export default function VisualTable({
  seats,
  occupiedSeats,
}: VisualTableProps) {
  return (
    <div className="aspect-square p-14">
      <div className="relative">
        <div className="absolute -inset-[1px] bg-gradient-to-r from-light-gold to-dark-gold aspect-square rounded-full" />
        <div className="relative aspect-square w-[5.25rem] rounded-full  flex items-center justify-center antialiased bg-white">
          {occupiedSeats === 0 ? "Livre" : `${seats - occupiedSeats} Livres`}
          <div className="absolute inset-0 translate-x-1/2 -translate-y-1/2">
            {generateSeats(seats, occupiedSeats)}
          </div>
        </div>
      </div>
    </div>
  );
}

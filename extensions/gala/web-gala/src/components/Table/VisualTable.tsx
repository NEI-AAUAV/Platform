import { useState } from "react";
import OnVisible from "react-on-visible";
import Wave from "react-wavify";
import Seat from "./Seat";

type VisualTableProps = {
  seats: number;
  occupiedSeats: number;
  className?: string;
};

function generateSeats(
  seats: number,
  occupiedSeats: number,
  visible: boolean,
): JSX.Element[] {
  const angleVariation = (2 * Math.PI) / seats;
  const initialAngle = Math.PI / 2;

  const totalTime = 150;
  const delayPerSeat = totalTime / seats;

  return Array.from({ length: seats }, (_, i) => {
    const isTaken = occupiedSeats > i;
    const angle = initialAngle - i * angleVariation;
    const delay = i * delayPerSeat;

    return (
      <Seat isTaken={isTaken} angle={angle} isVisible={visible} delay={delay} />
    );
  });
}

export default function VisualTable({
  seats,
  occupiedSeats,
  className,
}: VisualTableProps) {
  const [visible, setVisible] = useState(false);

  let vacancyState: JSX.Element;
  let backgroundColor = "bg-gradient-to-r from-light-gold to-dark-gold";
  switch (occupiedSeats) {
    case 0: {
      backgroundColor =
        "bg-gradient-radial from-light-gold to-[rgba(235, 213, 181, 0)";
      vacancyState = (
        <div
          className={`flex h-full w-full items-center justify-center overflow-hidden ${backgroundColor}`}
        >
          <span className="text-2xl font-bold">Livre</span>
        </div>
      );
      break;
    }
    case seats: {
      vacancyState = (
        <div
          className={`z-10 flex h-full w-full items-center justify-center overflow-hidden rounded-full ${backgroundColor}`}
        >
          <span className="font-bold">Ocupada</span>
        </div>
      );
      break;
    }
    default: {
      const freeSeats = seats - occupiedSeats;
      const percentageOfFreeSeats = (freeSeats / seats) * 100;

      vacancyState = (
        <div
          className="relative flex aspect-square flex-col items-center justify-center overflow-hidden rounded-full border border-transparent"
          style={{
            background:
              "linear-gradient(white, white) padding-box, linear-gradient(to right, #EBD5B5, #B6A080) border-box",
          }}
        >
          <Wave
            className="absolute inset-0 -rotate-6"
            fill="url(#gradient)"
            options={{
              // ! the percentage is inverted for reasons I don't understand
              height: percentageOfFreeSeats,
              amplitude: 4,
              speed: 0.25,
              points: 3,
            }}
          >
            <defs>
              <linearGradient id="gradient">
                <stop offset="0%" stopColor="#EBD5B5" />
                <stop offset="100%" stopColor="#B6A080" />
              </linearGradient>
            </defs>
          </Wave>
          <h1 className="z-10 text-[2rem] font-bold leading-tight">
            {freeSeats}
          </h1>
          <h6 className="z-10 text-xl font-light leading-tight">LIVRES</h6>
        </div>
      );
      break;
    }
  }

  return (
    <OnVisible
      className={`aspect-square p-14 ${className}`}
      onChange={() => setVisible(true)}
      percent={10}
    >
      <div className="relative aspect-square w-[6.25rem] select-none">
        {vacancyState}
        {generateSeats(seats, occupiedSeats, visible)}
      </div>
    </OnVisible>
  );
}

VisualTable.defaultProps = {
  className: "",
};

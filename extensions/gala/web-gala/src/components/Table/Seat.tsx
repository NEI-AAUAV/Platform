import classNames from "classnames";

type SeatProps = {
  angle: number;
  isTaken: boolean;
};

function cssCalcCoords(axis: number, gap: string) {
  const minRadius = "(1.25rem + 50%)";
  return `calc(${axis} * (${minRadius} + ${gap}))`;
}

export default function Seat({ angle, isTaken }: SeatProps) {
  const x = Math.cos(angle);
  const y = Math.sin(angle);
  const gap = "1rem";

  const style = {
    left: cssCalcCoords(x, gap),
    bottom: cssCalcCoords(y, gap),
  };

  return (
    <div
      className={classNames(
        "absolute -translate-x-1/2 translate-y-1/2 aspect-square w-10 rounded-full border-2 border-light-gold",
        {
          "bg-dark-gold border-dark-gold": isTaken,
        },
      )}
      style={style}
    />
  );
}

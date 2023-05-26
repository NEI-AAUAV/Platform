import classNames from "classnames";

type SeatProps = {
  angle: number;
  isTaken: boolean;
  isVisible: boolean;
  delay: number;
};

function cssCalcCoords(axis: number, gap: string) {
  const minRadius = "50% + 1.25rem";
  return `calc(${axis} * (${minRadius} + ${gap}))`;
}

export default function Seat({ angle, isTaken, isVisible, delay }: SeatProps) {
  const x = Math.cos(angle);
  const y = Math.sin(angle);
  const gap = "1rem";

  const style = isVisible
    ? {
        transform: `translate(${cssCalcCoords(x, gap)}, ${cssCalcCoords(
          -y,
          gap,
        )})`,
        opacity: 1,
        "transition-property": "transform, opacity",
        transition: `0.5s ease-in-out ${delay}ms`,
      }
    : { opacity: 0 };

  return (
    <div
      className="absolute inset-0 flex items-center justify-center"
      style={style}
    >
      <div
        className={classNames("aspect-square w-10 rounded-full border-2", {
          "border-light-gold": !isTaken,
          "border-dark-gold bg-dark-gold": isTaken,
        })}
      />
    </div>
  );
}

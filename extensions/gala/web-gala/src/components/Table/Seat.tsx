import classNames from "classnames";
import { useRef } from "react";

type SeatProps = {
  angle: number;
  isTaken: boolean;
  isVisible: boolean;
  delay: number;
};

function cssCalcCoords(
  axis: number,
  gap: string,
  ref: React.RefObject<HTMLDivElement>,
) {
  if (ref.current === null) throw new Error("Ref is null");
  const halfParentSize = ref.current.clientWidth;
  const minRadius = `${halfParentSize} + 1.25rem`;
  return `calc(${axis} * (${minRadius} + ${gap}))`;
}

export default function Seat({ angle, isTaken, isVisible, delay }: SeatProps) {
  const parentRef = useRef<HTMLDivElement>(null);

  const x = Math.cos(angle);
  const y = Math.sin(angle);
  const gap = "1rem";

  const style = isVisible
    ? {
        transform: `translate(${cssCalcCoords(
          x,
          gap,
          parentRef,
        )}, ${cssCalcCoords(-y, gap, parentRef)})`,
        opacity: 1,
        transitionProperty: "transform, opacity",
        transition: `0.5s ease-in-out ${delay}ms`,
      }
    : { opacity: 0 };

  return (
    <div
      className="absolute inset-0 flex items-center justify-center"
      ref={parentRef}
    >
      <div
        className={classNames("aspect-square w-10 rounded-full border-2", {
          "border-light-gold": !isTaken,
          "border-dark-gold bg-dark-gold": isTaken,
        })}
        style={style}
      />
    </div>
  );
}

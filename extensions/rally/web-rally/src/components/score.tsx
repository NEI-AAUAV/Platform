import { cn } from "@/lib/utils";
import type { ComponentProps } from "react";
import CustomBadge from "./custom-badge";
import { BloodyButton } from "./bloody-button";
import type { ListingTeam } from "@/client";
import { Link } from "react-router-dom";

type ScoreProps = { team: ListingTeam } & ComponentProps<"div">;

const nthNumber = (number: number) => {
  if (number > 3 && number < 21) return "th";
  switch (number % 10) {
    case 1:
      return "st";
    case 2:
      return "nd";
    case 3:
      return "rd";
    default:
      return "th";
  }
};

const variantClassification = (classification: number) => {
  switch (classification) {
    case 1:
      return "primary";
    case 2:
    case 3:
      return "default";
    default:
      return "neutral";
  }
};

export default function Score({ className, team, ...props }: ScoreProps) {
  const lastCheckpointTime =
    team.last_checkpoint_time && new Date(team.last_checkpoint_time);
  return (
    <div
      {...props}
      className={cn(
        "grid place-items-center gap-4 self-stretch rounded-2xl border-2 px-4 py-8",
        {
          "border-transparent bg-[rgb(255,255,255,0.15)]":
            team.classification === 1,
          "border-[rgb(255,255,255,0.15)] bg-[rgb(255,255,255,0.04)]":
            team.classification !== 1,
        },
        className,
      )}
    >
      <CustomBadge
        className="flex w-14 justify-center px-8 py-2 text-lg font-bold"
        variant={variantClassification(team.classification)}
      >
        {team.classification}
        {nthNumber(team.classification)}
      </CustomBadge>

      <span className="grow text-center text-2xl font-bold">{team.name}</span>
      <span className="grow text-center">
        {team.last_checkpoint_score}{" "}
        {lastCheckpointTime && (
          <span className="font-light text-white/60">
            | {lastCheckpointTime.getHours()}:{lastCheckpointTime.getMinutes()}
          </span>
        )}
      </span>
      <span className="grow text-center text-lg font-bold">
        {team.total}pts
      </span>
      <Link to={`/teams/${team.id}`}>
        <BloodyButton variant={"primary"} blood>
          View Team
        </BloodyButton>
      </Link>
    </div>
  );
}

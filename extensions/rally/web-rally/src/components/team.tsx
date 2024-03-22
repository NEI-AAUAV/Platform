import type { ListingTeam } from "@/client";
import { cn } from "@/lib/utils";
import { type ComponentProps } from "react";
import CustomBadge from "./custom-badge";
import { Link } from "react-router-dom";
import TeamImage from "./team-image";

type TeamProps = { team: ListingTeam } & Omit<
  ComponentProps<typeof Link>,
  "to"
>;

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
export default function Team({ team, className, ...props }: TeamProps) {
  return (
    <Link
      {...props}
      className={cn(
        "grid gap-8 rounded-2xl border-2 border-[rgb(255,255,255,0.15)] bg-[rgb(255,255,255,0.04)] p-8",
        className,
      )}
      to={`/teams/${team.id}`}
    >
      <CustomBadge
        className="flex justify-center place-self-center font-bold"
        variant={variantClassification(team.classification)}
      >
        {team.classification}
        {nthNumber(team.classification)}
        <span className="font-normal">&nbsp;| {team.total} points</span>
      </CustomBadge>
      <TeamImage teamId={team.id} />
      <p className="place-self-center text-xl font-bold">{team.name}</p>
    </Link>
  );
}

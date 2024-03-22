import { CheckPointService, TeamService } from "@/client";
import TeamImage from "@/components/team-image";
import { Button } from "@/components/ui/button";
import { useQuery } from "@tanstack/react-query";
import { ArrowBigLeft } from "lucide-react";
import { Link, Navigate, useParams } from "react-router-dom";

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

export default function TeamsById() {
  const { id } = useParams<{ id: string }>();

  const {
    data: team,
    isLoading,
    isSuccess,
    isError,
  } = useQuery({
    queryKey: ["team", id],
    queryFn: async () => {
      const response = await TeamService.getTeamByIdApiRallyV1TeamIdGet(
        Number(id),
      );
      return response;
    },
  });

  const { data: checkpoints } = useQuery({
    queryKey: ["checkpoints"],
    queryFn: CheckPointService.getCheckpointsApiRallyV1CheckpointGet,
  });

  if (isNaN(Number(id))) {
    return <Navigate to="/teams" />;
  }

  const lastCheckpoint = checkpoints?.find(
    (checkpoint) => checkpoint.id === team?.times.length,
  );
  const lastCheckpointTimeString = team?.times[team.times.length - 1];
  const lastCheckpointTime =
    lastCheckpointTimeString && new Date(lastCheckpointTimeString);

  return (
    <>
      <Button className="my-16 p-0" variant={"ghost"}>
        <Link to="/teams" className="flex">
          <ArrowBigLeft /> Go back to teams list
        </Link>
      </Button>

      {isLoading && <div>Loading...</div>}
      {isError && (
        <>
          <div>Something went wrong!</div>
          <div>The team you are trying to access may not exist!</div>
          <div>Try again later</div>
        </>
      )}
      {isSuccess && (
        <>
          <h2 className="mb-4 font-playfair text-2xl font-semibold">
            Team description and score
          </h2>
          <div className="mb-8 grid grid-cols-2 gap-16 rounded-2xl border-2 border-[rgb(255,255,255,0.15)] bg-[rgb(255,255,255,0.04)] p-8">
            <div>
              <p className="mb-4 min-h-[3.5rem] text-xl font-semibold">
                {team.name}
              </p>
              <div>
                <p className="mb-2">{team.total} points</p>
                <p className="text-sm font-light">
                  {team.classification}
                  {nthNumber(team.classification)} place
                </p>
              </div>
            </div>
            <TeamImage teamId={team.id} />
          </div>
          <h2 className="mb-4 font-playfair text-2xl font-semibold">
            Last Checkpoint
          </h2>
          <div className="mb-8 grid gap-4 rounded-2xl border-2 border-[rgb(255,255,255,0.15)] bg-[rgb(255,255,255,0.04)] p-8">
            <p className="text-center text-xl font-semibold">
              {lastCheckpoint?.name}
            </p>
            <p className="text-center font-light">
              {lastCheckpoint?.description}
            </p>
            <p className="text-center">
              {team.score_per_checkpoint[team.score_per_checkpoint.length - 1]}{" "}
              {lastCheckpointTime && (
                <span className="font-light text-white/60">
                  | {lastCheckpointTime.getHours()}:
                  {lastCheckpointTime.getMinutes()}
                </span>
              )}
            </p>
          </div>
          <h2 className="mb-4 font-playfair text-2xl font-semibold">
            Team Members
          </h2>
          <div className="grid gap-4">
            {team?.members.map((member) => {
              const names = member.name.split(" ");
              const firstName = names[0];
              const lastName = names.slice(1).join(" ");
              return (
                <div
                  className="rounded-2xl border border-[rgb(255,255,255,0.15)] bg-[rgb(255,255,255,0.04)] p-8 text-xl"
                  key={member.id}
                >
                  <span className="font-medium">{firstName}</span>{" "}
                  <span className="font-light">{lastName}</span>
                </div>
              );
            })}
          </div>
        </>
      )}
    </>
  );
}

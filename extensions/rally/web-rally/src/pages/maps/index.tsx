import { CheckPointService, TeamService } from "@/client";
import { BloodyButton } from "@/components/bloody-button";
import { useQuery } from "@tanstack/react-query";
import { ExternalLink } from "lucide-react";
import { Link } from "react-router-dom";

const GOOGLE_MAPS_URL = "https://www.google.com/maps/?q=";

export default function Maps() {
  const { data: checkpointMe } = useQuery({
    queryKey: ["checkpointMe"],
    queryFn: CheckPointService.getNextCheckpointApiRallyV1CheckpointMeGet,
  });

  const { data: checkpoints } = useQuery({
    queryKey: ["checkpoints"],
    queryFn: CheckPointService.getCheckpointsApiRallyV1CheckpointGet,
  });
  const { data: teamMe } = useQuery({
    queryKey: ["teamMe"],
    queryFn: TeamService.getOwnTeamApiRallyV1TeamMeGet,
  });
  const previousCheckpoints = checkpoints
    ?.filter((checkpoint) => checkpointMe && checkpoint.id < checkpointMe.id)
    .sort((a, b) => b.id - a.id);
  return (
    <>
      <h2 className="mb-4 mt-16 font-playfair text-2xl font-semibold">
        Próximo shot
      </h2>
      <div className="mb-8 grid place-items-center rounded-2xl border border-[rgb(255,255,255,0.15)] bg-[rgb(255,255,255,0.04)] p-8 text-xl font-semibold">
        {checkpointMe?.shot_name}
      </div>
      <h2 className="mb-4 font-playfair text-2xl font-semibold">
        Próximo checkpoint
      </h2>
      <div className="mb-8 grid place-items-center gap-4 rounded-2xl border border-[rgb(255,255,255,0.15)] bg-[rgb(255,255,255,0.04)] p-8">
        <p className="text-xl font-semibold">{checkpointMe?.name}</p>
        <p>{checkpointMe?.description}</p>
        <Link
          to={encodeURI(`${GOOGLE_MAPS_URL}${checkpointMe?.description} UA`)}
        >
          <BloodyButton className="flex gap-1" blood variant="primary">
            Google Maps <ExternalLink />
          </BloodyButton>
        </Link>
      </div>
      {previousCheckpoints?.length !== 0 && (
        <>
          <h2 className="mb-4 font-playfair text-2xl font-semibold">
            Checkpoints anteriores
          </h2>
          <div className="grid gap-4">
            {previousCheckpoints?.map((checkpoint, i) => {
              const score =
                teamMe &&
                teamMe.score_per_checkpoint[
                  teamMe.score_per_checkpoint.length - 1 - i
                ];
              const timeString =
                teamMe && teamMe.times[teamMe.times.length - 1 - i];
              const time = timeString && new Date(timeString);
              return (
                <div
                  key={checkpoint.id}
                  className="flex justify-between rounded-2xl border border-[rgb(255,255,255,0.15)] bg-[rgb(255,255,255,0.04)] p-8"
                >
                  <div>
                    <p className="text-xl font-semibold">{checkpoint.name}</p>
                    <p>{checkpoint.description}</p>
                  </div>
                  {teamMe && time && (
                    <div className="text-right">
                      <p className="font-medium">{score} pontos</p>
                      <p className="font-light">{`${time.getHours()}:${time.getMinutes()}`}</p>
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        </>
      )}
    </>
  );
}

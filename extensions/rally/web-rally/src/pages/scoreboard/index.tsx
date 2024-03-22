import Score from "@/components/score";
import { TeamService } from "@/client";
import { useQuery } from "@tanstack/react-query";

export default function Scoreboard() {
  const { data: teams } = useQuery({
    queryKey: ["teams"],
    queryFn: TeamService.getTeamsApiRallyV1TeamGet,
  });
  const sortedTeams = teams?.sort(
    (a, b) => a.classification - b.classification,
  );
  return (
    <div className="mt-16 grid gap-4">
      {sortedTeams?.map((team) => <Score key={team.id} team={team} />)}
    </div>
  );
}

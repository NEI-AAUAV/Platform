import { TeamService } from "@/client";
import Team from "@/components/team";
import { useQuery } from "@tanstack/react-query";

export default function Teams() {
  const { data: teams } = useQuery({
    queryKey: ["teams"],
    queryFn: TeamService.getTeamsApiRallyV1TeamGet,
  });
  const sortedTeams = teams?.sort(
    (a, b) => a.classification - b.classification,
  );
  return (
    <div className="mt-16 grid gap-8">
      {sortedTeams?.map((team) => <Team key={team.id} team={team} />)}
    </div>
  );
}

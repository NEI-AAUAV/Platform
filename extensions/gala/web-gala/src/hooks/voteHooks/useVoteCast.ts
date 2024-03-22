import GalaService from "@/services/GalaService";

export default async function useVoteCast(
  catId: number | string,
  request: { option: number },
) {
  await GalaService.vote.castVote(catId, request);
}

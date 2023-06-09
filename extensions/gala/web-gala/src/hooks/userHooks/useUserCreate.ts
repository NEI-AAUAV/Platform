import GalaService from "@/services/GalaService";

type CreateUser = {
  nmec: number | null;
  matriculation: number | null;
};

export default async function useUserCreate(request: CreateUser) {
  return await GalaService.user.createUser(request);
}

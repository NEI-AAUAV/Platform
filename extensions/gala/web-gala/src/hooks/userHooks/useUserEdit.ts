import GalaService from "@/services/GalaService";

type EditUser = {
  id: number;
  has_payed: boolean;
};

export default async function useUserEdit(request: EditUser) {
  return await GalaService.user.editUser(request);
}

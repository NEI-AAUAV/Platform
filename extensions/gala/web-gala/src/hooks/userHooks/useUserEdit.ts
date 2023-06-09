import GalaService from "@/services/GalaService";

type EditUser = {
  id: number;
  name: string;
  email: string;
  matriculation: number | null;
  nmec: number | null;
  has_payed: boolean;
};

export default async function useUserEdit(request: EditUser) {
  return await GalaService.user.editUser(request);
}

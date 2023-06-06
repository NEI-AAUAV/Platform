import GalaService from "@/services/GalaService";

type EditUser = {
  id: number;
  name: string;
  email: string;
  matriculation: number;
  nmec: number;
  has_payed: boolean;
};

export default function useUserEdit(request: EditUser) {
  GalaService.user.editUser(request);
}

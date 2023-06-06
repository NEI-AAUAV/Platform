import GalaService from "@/services/GalaService";

type CreateUser = {
  email: string;
  matriculation: number;
};

export default function useUserCreate(request: CreateUser) {
  GalaService.user.createUser(request);
}

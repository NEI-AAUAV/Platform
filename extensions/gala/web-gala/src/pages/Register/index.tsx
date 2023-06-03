import { useUserStore } from "@/stores/useUserStore";

export default function Register() {
  const user = useUserStore((state) => state);
  const name = user?.name || "Visitante";
  const id = user?.sub;
  const idType = typeof id;

  return (
    <h1 className="absolute inset-0 flex items-center justify-center text-center text-7xl">
      Olá {name}, com id {`${id} - ${idType}`}
    </h1>
  );
}

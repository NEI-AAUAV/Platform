import { useUserStore } from "@/stores/useUserStore";

export default function Inscription() {
  const name = useUserStore((state) => state.name);

  return (
    <h1 className="absolute inset-0 flex items-center justify-center text-center text-7xl">
      Olá {name}
    </h1>
  );
}

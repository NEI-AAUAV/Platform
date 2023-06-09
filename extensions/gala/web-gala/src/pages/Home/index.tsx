import { Link } from "react-router-dom";
import { useUserStore } from "@/stores/useUserStore";
import useSessionUser from "@/hooks/userHooks/useSessionUser";
import useLoginLink from "@/hooks/useLoginLink";

export default function Home() {
  const { sessionLoading, sub } = useUserStore((state) => ({
    sessionLoading: state.sessionLoading,
    sub: state.sub,
  }));
  const { sessionUser } = useSessionUser();
  const loginLink = useLoginLink();

  function navigateTo(path: string) {
    if (!sessionLoading && sub === undefined) {
      return loginLink;
    }
    if (sessionUser === undefined) {
      return "/register";
    }
    return path;
  }
  return (
    <div className="absolute inset-0 z-10 flex items-center justify-center">
      <div className="mx-4 flex flex-col items-center text-center text-base-content text-opacity-70">
        <h1 className="text-[2.5rem] font-bold leading-tight sm:text-[4rem]">
          O Melhor Jantar de Gala
        </h1>
        <h6 className="text-[1.75rem] sm:text-5xl">está aí à porta</h6>
        <Link
          className="mt-12 rounded-full bg-black/70 px-8 py-4 font-bold text-white backdrop-blur sm:text-[1.25rem]"
          to={navigateTo("/reserve")}
        >
          {!sessionLoading && sub === undefined
            ? "Login"
            : !sessionUser
            ? "Efetuar inscrição"
            : "Reservar Lugar"}
        </Link>
      </div>
    </div>
  );
}

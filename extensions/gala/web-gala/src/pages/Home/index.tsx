import { Link } from "react-router-dom";
import useSessionUser, { State } from "@/hooks/userHooks/useSessionUser";
import useLoginLink from "@/hooks/useLoginLink";

export default function Home() {
  const { state } = useSessionUser();
  const loginLink = useLoginLink();

  const header = {
    [State.NONE]: {
      label: "Iniciar sessão",
      link: loginLink,
    },
    [State.AUTHENTICATED]: {
      label: "Efetuar inscrição",
      link: "/register",
    },
    [State.REGISTERED]: {
      label: "Reservar Lugar",
      link: "/reserve",
    },
  };

  return (
    <div className="absolute inset-0 z-10 flex items-center justify-center">
      <div className="mx-4 flex flex-col items-center text-center text-base-content text-opacity-70">
        <h1 className="text-[2.5rem] font-bold leading-tight sm:text-[4rem]">
          O Melhor Jantar de Gala
        </h1>
        <h6 className="text-[1.75rem] sm:text-5xl">está aí à porta</h6>
        <Link
          className="mt-12 rounded-full bg-black/70 px-8 py-4 font-bold text-white backdrop-blur sm:text-[1.25rem]"
          to={header[state].link}
        >
          {header[state].label}
        </Link>
      </div>
    </div>
  );
}

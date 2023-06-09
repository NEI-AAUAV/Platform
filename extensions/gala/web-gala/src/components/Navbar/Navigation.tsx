import { Link, useLocation } from "react-router-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faChair, faCheckToSlot } from "@fortawesome/free-solid-svg-icons";
import { useUserStore, shallow } from "@/stores/useUserStore";
import Avatar from "../Avatar";
import useSessionUser from "@/hooks/userHooks/useSessionUser";
import config from "@/config";

type NavigationProps = {
  className?: string;
};

export default function Navigation({ className }: NavigationProps) {
  const location = useLocation().pathname;
  const { name } = useUserStore((state) => state, shallow);
  const { sessionLoading, sub } = useUserStore((state) => ({
    sessionLoading: state.sessionLoading,
    sub: state.sub,
  }));
  const { sessionUser } = useSessionUser();
  function navigateTo(path: string) {
    if (!sessionLoading && sub === undefined) {
      return `${config.BASE_URL}/auth/login/`;
    }
    if (sessionUser === undefined) {
      return "/register";
    }
    return path;
  }

  return (
    <nav className={className}>
      <ul className="flex flex-col gap-4 sm:flex-row md:gap-8">
        <li>
          <Link
            className={`block rounded-3xl px-4 py-2 ${
              location.startsWith("/reserve") &&
              "bg-gradient-to-r from-light-gold to-dark-gold"
            }`}
            to={navigateTo("/reserve")}
          >
            <FontAwesomeIcon icon={faChair} /> Reservar Lugar
          </Link>
        </li>
        <li>
          <Link
            className={`block rounded-3xl px-4 py-2 ${
              location.startsWith("/vote") &&
              "bg-gradient-to-r from-light-gold to-dark-gold"
            }`}
            to={navigateTo("/vote")}
          >
            <FontAwesomeIcon icon={faCheckToSlot} /> Votar
          </Link>
        </li>
        {name !== undefined && (
          <li>
            <Link className="px-2 py-2" to="/register" title={name}>
              <Avatar alt="profile" className="w-5" />{" "}
              <span className="sm:hidden">{name}</span>
            </Link>
          </li>
        )}
      </ul>
    </nav>
  );
}

Navigation.defaultProps = {
  className: "",
};

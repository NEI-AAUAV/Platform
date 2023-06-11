import { Link, useLocation } from "react-router-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faChair,
  faCheckToSlot,
  faUsersGear,
} from "@fortawesome/free-solid-svg-icons";
import { useUserStore, shallow } from "@/stores/useUserStore";
import Avatar from "../Avatar";

type NavigationProps = {
  className?: string;
};

export default function Navigation({ className }: NavigationProps) {
  const location = useLocation().pathname;
  const { name, scopes } = useUserStore((state) => state, shallow);

  return (
    <nav className={className}>
      <ul className="flex flex-col gap-4 md:flex-row md:gap-8">
        <li>
          <Link
            className={`block rounded-3xl px-4 py-2 ${
              location.startsWith("/reserve") &&
              "bg-gradient-to-r from-light-gold to-dark-gold"
            }`}
            to="/reserve"
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
            to="/vote"
          >
            <FontAwesomeIcon icon={faCheckToSlot} /> Votar
          </Link>
        </li>
        {scopes?.includes("admin") && (
          <li>
            <Link
              className={`block rounded-3xl px-4 py-2 ${
                location.startsWith("/admin") &&
                "bg-gradient-to-r from-light-gold to-dark-gold"
              }`}
              to="/admin"
            >
              <FontAwesomeIcon icon={faUsersGear} /> Admin
            </Link>
          </li>
        )}
        {name !== undefined && (
          <li className="flex items-center">
            <Link className="px-2" to="/register" title={name}>
              <Avatar alt="profile" className="my-auto w-5" />{" "}
              <span className="my-auto sm:hidden">{name}</span>
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

import { Link, useLocation } from "react-router-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faChair, faCheckToSlot } from "@fortawesome/free-solid-svg-icons";
import { useUserStore, shallow } from "@/stores/useUserStore";

type NavigationProps = {
  className?: string;
};

export default function Navigation({ className }: NavigationProps) {
  const location = useLocation().pathname;
  const { image, name } = useUserStore(
    (state) => ({ image: state.image, name: state.name }),
    shallow,
  );

  return (
    <nav className={className}>
      <ul className="flex flex-col gap-4 sm:flex-row md:gap-8">
        <li>
          <Link
            className={`block rounded-3xl px-4 py-2 ${
              location === "/tables" &&
              "bg-gradient-to-r from-light-gold to-dark-gold"
            }`}
            to="/tables"
          >
            <FontAwesomeIcon icon={faChair} /> Reservar Lugar
          </Link>
        </li>
        <li>
          <Link
            className={`block rounded-3xl px-4 py-2 ${
              location === "/vote" &&
              "bg-gradient-to-r from-light-gold to-dark-gold"
            }`}
            to="/vote"
          >
            <FontAwesomeIcon icon={faCheckToSlot} /> Votar
          </Link>
        </li>
        {!!image && (
          <li>
            <Link
              className={`block overflow-hidden rounded-full border-2  border-light-gold`}
              to="/inscription"
              title={name}
            >
              <img src={image} alt="profile" className="h-9 w-9" />
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

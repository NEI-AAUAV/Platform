import { Link } from "react-router-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faChair, faCheckToSlot } from "@fortawesome/free-solid-svg-icons";

type NavigationProps = {
  className?: string;
};

export default function Navigation({ className }: NavigationProps) {
  return (
    <nav className={className}>
      <ul className="flex flex-col gap-4 md:gap-8 sm:flex-row">
        <li>
          <Link to="/tables">
            <FontAwesomeIcon icon={faChair} /> Reservar Lugar
          </Link>
        </li>
        <li>
          <Link to="/vote">
            <FontAwesomeIcon icon={faCheckToSlot} /> Votar
          </Link>
        </li>
      </ul>
    </nav>
  );
}

Navigation.defaultProps = {
  className: "",
};

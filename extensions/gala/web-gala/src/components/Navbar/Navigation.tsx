import { Link } from "react-router-dom";

type NavigationProps = {
  className?: string;
};

export default function Navigation({ className }: NavigationProps) {
  return (
    <nav className={className}>
      <ul className="flex flex-col gap-3 md:gap-6 sm:flex-row font-light">
        <li>
          <Link to="/tables">Reservar Lugar</Link>
        </li>
        <li>
          <Link to="/vote">Votar</Link>
        </li>
      </ul>
    </nav>
  );
}

Navigation.defaultProps = {
  className: "",
};
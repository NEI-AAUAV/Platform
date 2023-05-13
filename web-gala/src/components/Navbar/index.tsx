import { useState } from "react";
import { Link } from "react-router-dom";
import { LogoIcon, HamburgerIcon } from "@/assets/icons";
import Navigation from "./Navigation";

export default function Navbar() {
  const [isOpen, setIsOpen] = useState(false);
  return (
    <header
      className={`p-3 ${
        isOpen ? "bg-white rounded-b-xl sm:bg-transparent sm:rounded-none" : ""
      }`}
    >
      <div className="flex">
        <Link className="flex gap-3" to="/gala">
          <LogoIcon className="" />
          <span className="text-xl font-bold">Jantar de Gala</span>
        </Link>
        <div className="hidden sm:block ml-auto">
          <Navigation />
        </div>
        <button
          className="ml-auto sm:hidden"
          onClick={() => setIsOpen((prev) => !prev)}
          type="button"
        >
          <HamburgerIcon />
        </button>
      </div>
      <div className="flex sm:hidden overflow-hidden">
        <Navigation
          className={`overflow-hidden transition-all duration-200 ease-out ${
            isOpen ? "basis-auto" : "basis-0"
          }`}
        />
      </div>
    </header>
  );
}

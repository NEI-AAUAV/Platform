import { useState } from "react";
import { motion } from "framer-motion";
import { Link } from "react-router-dom";
import { LogoIcon, HamburgerIcon } from "@/assets/icons";
import Navigation from "./Navigation";

export default function Navbar() {
  const [isOpen, setIsOpen] = useState(false);
  const background = isOpen ? "bg-white rounded-b-xl" : "";
  return (
    <header
      className={`sm:bg-transparent sm:rounded-none sticky top-0 p-3 transition-[background-color] md:delay-100 ease-linear ${background}`}
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
      <motion.div
        animate={{ height: isOpen ? "auto" : 0 }}
        className={`outline fixed left-0 px-3 first-letter:sm:hidden overflow-hidden w-full ${background}`}
      >
        <Navigation className="pt-8 pb-3" />
      </motion.div>
    </header>
  );
}

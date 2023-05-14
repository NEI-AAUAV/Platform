import { useState } from "react";
import { motion } from "framer-motion";
import classNames from "classnames";
import { Link } from "react-router-dom";
import { LogoIcon, HamburgerIcon } from "@/assets/icons";
import Navigation from "./Navigation";

export default function Navbar() {
  const [isOpen, setIsOpen] = useState(false);
  const background = "bg-white rounded-b-xl";
  return (
    <>
      <header
        className={classNames(
          "sm:bg-transparent sm:rounded-none sticky top-0 z-40 p-3 transition-[background-color]",
          {
            [background]: isOpen,
          },
        )}
      >
        <div className="flex">
          <Link className="flex gap-3" to="/">
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
          className={classNames(
            " left-0 px-3 sm:hidden overflow-hidden w-full",
          )}
        >
          <Navigation className="pt-8 pb-3" />
        </motion.div>
      </header>
      <div
        className={classNames("modal z-30 bg-opacity-70", {
          "modal-open": isOpen,
        })}
        onClick={() => setIsOpen(false)}
      />
    </>
  );
}

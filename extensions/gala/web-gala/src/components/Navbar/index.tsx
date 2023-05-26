import { useEffect, useState } from "react";
import { motion } from "framer-motion";
import classNames from "classnames";
import { Link } from "react-router-dom";
import { LogoIcon, HamburgerIcon } from "@/assets/icons";
import Navigation from "./Navigation";

export default function Navbar() {
  const [isOpen, setIsOpen] = useState(false);
  const background = "bg-white rounded-b-xl";

  useEffect(() => {
    function handleResize() {
      const sm = 640;
      if (window.innerWidth > sm) {
        setIsOpen(false);
      }
    }

    window.addEventListener("resize", handleResize);

    return () => {
      window.removeEventListener("resize", handleResize);
    };
  }, []);

  return (
    <>
      <header
        className={classNames(
          "sticky top-0 z-40 p-3 text-base-content text-opacity-70 transition-[background-color] sm:rounded-none sm:bg-transparent",
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
          <div className="ml-auto hidden sm:block">
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
            " left-0 w-full overflow-hidden px-3 sm:hidden",
          )}
        >
          <Navigation className="pb-3 pt-8" />
        </motion.div>
      </header>
      <div
        aria-hidden="true"
        className={classNames("modal z-30 bg-opacity-70", {
          "modal-open": isOpen,
        })}
        onClick={() => setIsOpen(false)}
      />
    </>
  );
}

import { useEffect, useState } from "react";
import { motion } from "framer-motion";
import classNames from "classnames";
import { Link } from "react-router-dom";
import { LogoIcon, HamburgerIcon } from "@/assets/icons";
import Navigation from "./Navigation";
import useWindowScroll from "@/hooks/useWindowScroll";

export default function Navbar() {
  const [isOpen, setIsOpen] = useState(false);
  const background = "bg-base-100 shadow-xl";
  const headerTransition = {
    transition: `background-color 0.15s ease-in-out ${
      isOpen ? 0 : 0.1
    }s, box-shadow 0.15s ease-in-out ${isOpen ? 0.1 : 0}s`,
  };
  const [counter, setCounter] = useState(0);
  const { x } = useWindowScroll();

  useEffect(() => {
    function handleResize() {
      const md = 768;
      if (window.innerWidth > md) {
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
          "sticky top-0 z-40 p-5 text-base-content text-opacity-70 md:rounded-none md:bg-transparent",
          {
            [background]: isOpen,
            "backdrop-blur": x !== undefined && x > 0,
          },
        )}
        style={headerTransition}
      >
        <div className="flex">
          <button
            type="button"
            onClick={() => {
              setCounter((prev) => prev + 1);
              if (counter > 68) {
                setCounter(() => 0);
                window.location.href =
                  "https://www.youtube.com/watch?v=dQw4w9WgXcQ";
              }
            }}
          >
            <Link className="flex gap-3" to="/">
              <LogoIcon className="" />
              <span className="text-xl font-bold">Jantar de Gala</span>
            </Link>
          </button>

          <div className="ml-auto hidden md:block">
            <Navigation />
          </div>
          <button
            className="ml-auto md:hidden"
            onClick={() => setIsOpen((prev) => !prev)}
            type="button"
          >
            <HamburgerIcon />
          </button>
        </div>
        <motion.div
          animate={{ height: isOpen ? "auto" : 0 }}
          transition={{ delay: isOpen ? 0.1 : 0, duration: 0.3 }}
          className={classNames(
            "absolute left-0 h-0 w-full overflow-hidden rounded-b-xl bg-inherit px-3 md:hidden",
          )}
        >
          <Navigation className="pb-3 pt-8" />
        </motion.div>
      </header>
      <div
        aria-hidden="true"
        className={classNames(
          "modal z-30 bg-opacity-70 transition-[visibility,opacity]",
          {
            "modal-open delay-100": isOpen,
          },
        )}
        onClick={() => setIsOpen(false)}
      />
    </>
  );
}

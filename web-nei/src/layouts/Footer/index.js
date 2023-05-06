import React from "react";

import blackLogo from "assets/images/logo/horizontal/black.png";
import whiteLogo from "assets/images/logo/horizontal/white.png";

import blackMapBg from "assets/images/background/map-black.png";
import whiteMapBg from "assets/images/background/map-white.png";

import { MailIcon, LocationIcon } from "assets/icons/google";

import { useUserStore } from "stores/useUserStore";
import { data } from "./data";
import classNames from "classnames";

const Footer = () => (
  <footer className="relative mt-auto">
    <div className="footer mx-auto flex h-16 w-full max-w-[90rem] items-center justify-center gap-4 py-4 px-1 sm:px-4 flex-row sm:justify-between">
      <div className="grid-flow-col items-center">
        <p className="xs:ml-2">
          &copy; {new Date().getFullYear()} - <span className="hidden sm:inline-block">All right reserved by</span>{" "}NEI-AAUAv.
        </p>
      </div>
      <div className="grid-flow-col gap-1.5 sm:gap-3 md:place-self-center md:justify-self-end">
        {data.map(({ icon, url, secondary }, index) => (
          <a
            key={index}
            href={url}
            target="_blank"
            className={classNames(
              "btn-ghost btn-sm btn-circle btn sm:flex",
              secondary && "hidden"
            )}
          >
            {icon}
          </a>
        ))}
      </div>
    </div>
  </footer>
);

const MainFooter = () => {
  const theme = useUserStore((state) => state.theme);
  return (
    <footer
      className="relative mt-auto bg-cover bg-center shadow-inner"
      style={{
        backgroundImage:
          theme === "dark" ? `url(${blackMapBg})` : `url(${whiteMapBg})`,
      }}
    >
      <div className="footer mx-auto w-full max-w-[90rem] p-3 xs:p-10 text-base-content md:justify-normal justify-center">
        <div>
          <img
            src={theme === "dark" ? whiteLogo : blackLogo}
            alt="NEI"
            className="h-24 md:h-32 -mt-2"
          />
          <p className="ml-2">
            Núcleo de Estudantes de Informática da AAUAv
            <br />A apoiar os estudantes desde 2013.
          </p>
          <p className="ml-2">
            &copy; {new Date().getFullYear()} - All right reserved by NEI-AAUAv.
          </p>
        </div>
        <div>
          <span className="footer-title">Contacto</span>
          <span className="ml-1 inline-flex min-h-[2rem] items-center gap-3">
            <LocationIcon />
            <a
              href="https://goo.gl/maps/JZY6mi3T9T6UxE3z6"
              className="link-hover link"
            >
              3810-193 Aveiro, Portugal
            </a>
          </span>
          <span className="ml-1 inline-flex min-h-[2rem] items-center gap-3">
            <MailIcon />
            <a href="mailto:nei@aauav.pt" className="link-hover link">
              nei@aauav.pt
            </a>
          </span>

          <span className="footer-title mt-4">Social</span>
          <div className="grid grid-flow-col gap-4">
            {data.map(({ icon, url, secondary }, index) => (
              <a
                key={index}
                href={url}
                target="_blank"
                className={classNames(
                  "btn-ghost btn-sm btn-circle btn xs:flex",
                  secondary && "hidden"
                )}
              >
                {icon}
              </a>
            ))}
          </div>
        </div>
      </div>
    </footer>
  );
};

export { Footer as default, MainFooter };

import React from "react";

import blackLogo from "assets/images/logo/horizontal/black.png";
import whiteLogo from "assets/images/logo/horizontal/white.png";

import blackMapBg from "assets/images/background/map-black.png";
import whiteMapBg from "assets/images/background/map-white.png";

import { MailIcon, LocationIcon } from "assets/icons/google";

import { useUserStore } from "stores/useUserStore";
import { data } from "./data";

const Footer = () => (
  <footer className="relative">
    <div className="h-16 footer mx-auto flex w-full max-w-[90rem] flex-col-reverse items-center justify-center gap-1 p-4 xs:flex-row xs:justify-between">
      <div className="grid-flow-col items-center">
        <p className="xs:ml-2"> 
          &copy; {new Date().getFullYear()} - All right reserved by NEI-AAUAv.
        </p>
      </div>
      <div className="grid-flow-col gap-3 md:place-self-center md:justify-self-end">
        {data.map(({ icon, url }, index) => (
          <a
            key={index}
            href={url}
            target="_blank"
            className="btn-ghost btn-sm btn-circle btn"
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
      className="relative bg-cover bg-center shadow-inner"
      style={{
        backgroundImage:
          theme === "dark" ? `url(${blackMapBg})` : `url(${whiteMapBg})`,
      }}
    >
      <div className="footer mx-auto w-full max-w-[90rem] p-10 !text-inherit text-neutral-content">
        <div>
          <img
            src={theme === "dark" ? whiteLogo : blackLogo}
            alt="NEI"
            className="h-24 md:h-32"
          />
          <p className="ml-2">
            Núcleo de Estudantes de Informática da AAUAv 
            <br />
            A apoiar os estudantes desde 2013.
          </p>
          <p className="ml-2">
            &copy; {new Date().getFullYear()} - All right reserved by NEI-AAUAv.
          </p>
        </div>
        <div>
          <span className="footer-title">Contacto</span>
          <span className="ml-1 inline-flex min-h-[2rem] items-center gap-3">
            <LocationIcon />
            3810-193 Aveiro, Portugal
          </span>
          <span className="ml-1 inline-flex min-h-[2rem] items-center gap-3">
            <MailIcon />
            <a href="mailto:nei@aauav.pt" className="link link-hover">nei@aauav.pt</a>
          </span>

          <span className="footer-title mt-4">Social</span>
          <div className="grid grid-flow-col gap-4">
            {data.map(({ icon, url }, index) => (
              <a
                key={index}
                href={url}
                target="_blank"
                className="btn-ghost btn-sm btn-circle btn"
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
